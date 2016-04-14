//
//  LLAsset.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAsset.h"

@interface LLAsset()

@property (nonatomic, strong) id asset;
@property (nonatomic, assign) LLMediaType mediaType;

//------------------------ photo ------------------------//
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, assign) UIImageOrientation imageOrientation;

//------------------------ video ------------------------//
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSDictionary *playerItemInfo;

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@end

@implementation LLAsset

+ (LLAsset *)assetWithItem:(id)asset {
    
    LLAsset *myAsset = [[LLAsset alloc] init];
    myAsset.asset = asset;
    myAsset.isSelected = NO;
    
    return myAsset;
}

- (LLMediaType)mediaType {
    
    if (_mediaType) {
        return _mediaType;
    }
    
    if (iOS8Later) {
        
        PHAsset *asset = _asset;
        switch (asset.mediaType) {
            
            case PHAssetMediaTypeImage: {
                
                _mediaType = kMediaTypePhoto;
                break;
            }
            case PHAssetMediaTypeVideo: {
                
                _mediaType = kMediaTypeVideo;
                _time = [NSString stringWithFormat:@"%f", asset.duration];
                break;
            }
            default:
                break;
        }
    }
    else {
        
        ALAsset *asset = _asset;
        NSString *assetType = [asset valueForProperty:ALAssetPropertyType];
        if ([assetType isEqualToString:ALAssetTypePhoto]) {
            
            _mediaType = kMediaTypePhoto;
        }
        else {
            
            _mediaType = kMediaTypeVideo;
            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
            _time = [NSString stringWithFormat:@"%0.0f",duration];
        }
    }
    return _mediaType;
}

- (PHCachingImageManager *)cachingImageManager {
    
    return [[PHCachingImageManager alloc] init];
}

- (UIImage *)originImage {
    
    if (_originImage) {
        return _originImage;
    }
    __block UIImage *resultImage;
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
        imageRequestOption.synchronous = YES;
        [self.cachingImageManager requestImageForAsset:_asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOption resultHandler:^(UIImage *result, NSDictionary *info) {
            resultImage = result;
        }];
    }
    else {
        
        CGImageRef fullResolutionImageRef = [[(ALAsset *)_asset defaultRepresentation] fullResolutionImage];
        NSString *adjustment = [[[(ALAsset *)_asset defaultRepresentation] metadata] objectForKey:@"AdjustmentXMP"];
        if (adjustment) {
            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
            
            NSError *error;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                         inputImageExtent:tempImage.extent
                                                                    error:&error];
            CIContext *context = [CIContext contextWithOptions:nil];
            if (filterArray && !error) {
                for (CIFilter *filter in filterArray) {
                    [filter setValue:tempImage forKey:kCIInputImageKey];
                    tempImage = [filter outputImage];
                }
                fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
            }
        }
        resultImage = [UIImage imageWithCGImage:fullResolutionImageRef scale:[[_asset defaultRepresentation] scale] orientation:(UIImageOrientation)[[_asset defaultRepresentation] orientation]];
    }
    _originImage = resultImage;
    return _originImage;
}

- (UIImage *)thumbnail {
    
    if (_thumbnail) {
        return _thumbnail;
    }
    
    _thumbnail = [self imageWithSize:kLLThumbnailSize];
    return _thumbnail;
}

- (UIImage *)previewImage {
    
    if (_previewImage) {
        
        return _previewImage;
    }
    
    _previewImage = [self imageWithSize:kScreenSize];
    return _previewImage;
}

- (UIImageOrientation)imageOrientation {
    if (_imageOrientation) {
        return _imageOrientation;
    }
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [self.cachingImageManager requestImageDataForAsset:_asset options:imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            _imageOrientation = orientation;
        }];
    } else {
        _imageOrientation = [[_asset valueForProperty:@"ALAssetPropertyOrientation"] integerValue];
    }
    return _imageOrientation;
}

- (AVPlayerItem *)playerItem {
    if (_playerItem) {
        return _playerItem;
    }
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [self getVideoInfoCompletionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    _playerItem = resultItem;
    _playerItemInfo = resultItemInfo ? : _playerItemInfo;
    return _playerItem;
}

- (NSDictionary *)playerItemInfo {
    
    if (_playerItemInfo) {
        return _playerItemInfo;
    }
    
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [self getVideoInfoCompletionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    
    _playerItem = resultItem;
    _playerItemInfo = resultItemInfo ? : _playerItemInfo;
    
    return _playerItemInfo;
}

- (void)getVideoInfoCompletionBlock:(void (^)(AVPlayerItem *, NSDictionary *))completionBlock {
    if ([_asset isKindOfClass:[PHAsset class]]) {
        
        [[PHImageManager defaultManager] requestPlayerItemForVideo:_asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            completionBlock(playerItem,info);
        }];
    } else if ([_asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)_asset;
        ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
        NSString *uti = [defaultRepresentation UTI];
        NSURL *videoURL = [[_asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
        completionBlock(playerItem,nil);
    }
}

- (UIImage *)imageWithSize:(CGSize)size {
    
    __block UIImage *resultImage;
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
//        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        CGSize scaledsize = CGSizeMake(size.width * kLLScreenScale, size.height * kLLScreenScale);
        [self.cachingImageManager requestImageForAsset:_asset targetSize:scaledsize contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            
            resultImage = result;
        }];
    } else {
        CGImageRef thumbnailImageRef = [(ALAsset *)_asset thumbnail];
        if (thumbnailImageRef) {
            
            resultImage = [UIImage imageWithCGImage:thumbnailImageRef];
        }
    }
    return resultImage;
}
@end

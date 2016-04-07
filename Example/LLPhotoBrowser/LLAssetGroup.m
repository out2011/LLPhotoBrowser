//
//  LLAssetGroup.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetGroup.h"

@interface LLAssetGroup()

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@end

@implementation LLAssetGroup

+ (LLAssetGroup *)groupWithResult:(id)result name:(NSString *)name {
    
    LLAssetGroup *group = [[LLAssetGroup alloc] init];
    group.fetchResult = result;
    group.name = [self albumNameWithSystemName:name];
    
    if ([result isKindOfClass:[PHFetchResult class]]) {
        
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        group.count = fetchResult.count;
    }
    else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        group.count = [gruop numberOfAssets];
    }
    return group;
}

- (PHCachingImageManager *)cachingImageManager {
    
    return [[PHCachingImageManager alloc] init];
}

- (UIImage *)thumbnail {
    
    id asset = [_fetchResult lastObject];
    
    __block UIImage *resultImage;
    if (iOS8Later) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        CGSize size = CGSizeMake(kLLThumbnailSize.width * kLLScreenScale, kLLThumbnailSize.height * kLLScreenScale);
        [self.cachingImageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            
            resultImage = result;
        }];
    } else {
        CGImageRef thumbnailImageRef = [(ALAsset *)asset thumbnail];
        if (thumbnailImageRef) {
            
            resultImage = [UIImage imageWithCGImage:thumbnailImageRef];
        }
    }
    return resultImage;
}

+ (NSString *)albumNameWithSystemName:(NSString *)name {
    
    if (iOS8Later) {
        NSString *newName;
        if ([name containsString:@"Roll"])         newName = @"相机胶卷";
        else if ([name containsString:@"Stream"])  newName = @"我的照片流";
        else if ([name containsString:@"Added"])   newName = @"最近添加";
        else if ([name containsString:@"Selfies"]) newName = @"自拍";
        else if ([name containsString:@"shots"])   newName = @"截屏";
        else if ([name containsString:@"Videos"])  newName = @"视频";
        else newName = name;
        return newName;
    } else {
        return name;
    }
}

@end

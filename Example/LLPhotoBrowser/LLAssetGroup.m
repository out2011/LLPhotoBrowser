//
//  LLAssetGroup.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetGroup.h"

@interface LLAssetGroup()

/// 相册名称
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) id fetchResult;

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
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if (iOS8Later && [currentLanguage isEqualToString:@"zh-Hans-US"]) {
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

//
//  LLAssetGroup.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetGroup.h"

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

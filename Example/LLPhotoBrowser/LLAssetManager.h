//
//  LLAssetManager.h
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LLPhotoDefine.h"
#import <Photos/Photos.h>

/// 媒体类型
typedef NS_ENUM(NSInteger, LLMediaType){
    
    kMediaTypeNormal = 0,
    kMediaTypePhoto,
    kMediaTypeVideo
};

/// 照片展示类型
typedef NS_ENUM(NSInteger, LLBrowserType){
    
    kBrowserNormal = 0,  // photo and video
    kBrowserPhoto,       // only photo
    kBrowserVideo,       // only video
    kBrowserAlbum,       // photo album
    kBrowserPlay
};

@interface LLAssetManager : NSObject

+ (LLAssetManager *)shareInstance;

- (NSArray *)allAssetsWithType:(LLBrowserType)type;

- (NSArray *)allAssetGroups;

- (NSArray *)assetsWithGroup:(id)group filterType:(LLBrowserType)type;


@end

#import "LLAsset.h"
#import "LLAssetGroup.h"

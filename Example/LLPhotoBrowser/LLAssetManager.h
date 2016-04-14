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

@property (nonatomic, strong, readonly) NSArray *selectedAssets;
@property (nonatomic, assign) NSInteger maxNumber;

+ (LLAssetManager *)shareInstance;

/// 根据分类在所有照片中过滤对象
- (NSArray *)allAssetsWithType:(LLBrowserType)type;

/// 所有相册
- (NSArray *)allAssetGroups;

/// 根据分类在当前相册中过滤对象
- (NSArray *)assetsWithGroup:(id)group type:(LLBrowserType)type;

/// 讲选中照片存入manager
- (void)fillSelectedAssets:(NSMutableArray *)assets;
@end

#import "LLAsset.h"
#import "LLAssetGroup.h"

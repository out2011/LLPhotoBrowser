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

typedef NS_ENUM(NSInteger, LLMediaType){
    
    kMediaTypeNormal = 0,
    kMediaTypePhoto,
    kMediaTypeVideo
};

@interface LLAssetManager : NSObject

+ (LLAssetManager *)shareInstance;

- (NSArray *)filterAssets:(NSArray *)assets WithType:(LLMediaType)type;

- (NSArray *)allAssetGroups;

- (NSArray *)assetsWithGroup:(id)group filterType:(LLMediaType)type;
@end

#import "LLAsset.h"
#import "LLAssetGroup.h"

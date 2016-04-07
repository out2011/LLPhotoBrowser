//
//  LLAssetGroup.h
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"

@interface LLAssetGroup : NSObject

/// 相册名称
@property (nonatomic, strong) NSString *name;

/// 当前相册照片数量
@property (nonatomic, assign) NSUInteger count;

/// 缩略图 80*80
@property (nonatomic, strong) UIImage *thumbnail;

/// PHFetchResult <PHAsset for iOS8 later> or ALAssetsGroup<ALAsset for iOS8 before>
@property (nonatomic, strong) id fetchResult;

+ (LLAssetGroup *)groupWithResult:(id)result name:(NSString *)name;

@end

//
//  LLAsset.h
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"

@interface LLAsset : NSObject

/// PHAsset/ALAsset
@property (nonatomic, strong, readonly) id asset;
/// 类型
@property (nonatomic, assign, readonly) LLMediaType mediaType;
/// 选中状态
@property (nonatomic, assign) BOOL isSelected;

//------------------------ photo ------------------------//
/// 原图
@property (nonatomic, strong, readonly) UIImage *originImage;

/// 缩略图 80*80
@property (nonatomic, strong, readonly) UIImage *thumbnail;

/// 预览图 screen size
@property (nonatomic, strong, readonly) UIImage *previewImage;

/// 图片方向
@property (nonatomic, assign, readonly) UIImageOrientation imageOrientation;


//------------------------ video ------------------------//
/// 时长
@property (nonatomic, strong, readonly) NSString *time;

/// 视频item
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

/// 视频item信息
@property (nonatomic, strong, readonly) NSDictionary *playerItemInfo;

+ (LLAsset *)assetWithItem:(id)asset;
@end

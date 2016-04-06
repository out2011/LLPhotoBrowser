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
@property (nonatomic, strong) id asset;
/// 类型
@property (nonatomic, assign) LLMediaType mediaType;

//------------------------ photo ------------------------//
/// 原图
@property (nonatomic, strong) UIImage *originImage;

/// 缩略图 80*80
@property (nonatomic, strong) UIImage *thumbnail;

/// 预览图 screen size
@property (nonatomic, strong) UIImage *previewImage;

/// 图片方向
@property (nonatomic, assign) UIImageOrientation imageOrientation;


//------------------------ video ------------------------//
/// 时长
@property (nonatomic, strong) NSString *time;

/// 视频item
@property (nonatomic, strong) AVPlayerItem *playerItem;

/// 视频item信息
@property (nonatomic, strong) NSDictionary *playerItemInfo;

+ (LLAsset *)assetWithItem:(id)asset;
@end

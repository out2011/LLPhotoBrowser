//
//  LLPhotoDefine.h
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#ifndef LLPhotoDefine_h
#define LLPhotoDefine_h

#import <UIKit/UIDevice.h>
#import <UIKit/UIKit.h>

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kLLThumbnailSize CGSizeMake(80, 80)

#define kLLScreenScale [UIScreen mainScreen].scale

#endif /* LLPhotoDefine_h */

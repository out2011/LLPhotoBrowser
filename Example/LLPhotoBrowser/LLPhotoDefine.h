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

#define kLLThumbnailSize CGSizeMake(80, 80)


#endif /* LLPhotoDefine_h */
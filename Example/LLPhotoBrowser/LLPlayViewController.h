//
//  LLPlayViewController.h
//  Example
//
//  Created by Lu.L on 16/4/7.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"

@interface LLPlayViewController : UIViewController

@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, assign) NSInteger currentIndex;

@end

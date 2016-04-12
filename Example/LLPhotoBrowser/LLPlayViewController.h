//
//  LLPlayViewController.h
//  Example
//
//  Created by Lu.L on 16/4/7.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"

typedef void (^assetsSelectedBlock)(NSArray *selectedAssets);

@interface LLPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) assetsSelectedBlock block;

@end

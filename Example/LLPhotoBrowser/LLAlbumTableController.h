//
//  LLAlbumTableController.h
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"

@interface LLAlbumTableController : UITableViewController

@property (nonatomic, strong) LLAssetManager *assetManager;

@property (nonatomic, assign) LLBrowserType browserType;

@end

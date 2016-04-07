//
//  LLPhotoCollectionController.h
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAlbumTableController.h"

@interface LLPhotoCollectionController : UICollectionViewController

@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, assign) LLBrowserType browserType;

@end

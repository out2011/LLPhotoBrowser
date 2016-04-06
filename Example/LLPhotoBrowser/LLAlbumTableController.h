//
//  LLAlbumTableController.h
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetManager.h"


typedef NS_ENUM(NSInteger, LLBrowserType){
    
    kBrowserNormal = 0,  // photo and video
    kBrowserPhoto,       // only photo
    kBrowserVideo,       // only video
    kBrowserAlbum,       // photo album
    kBrowserPlay
};

@interface LLAlbumTableController : UITableViewController

@property (nonatomic, strong) LLAssetManager *assetManager;

@property (nonatomic, assign) LLBrowserType browserType;

@property (nonatomic, assign) LLMediaType mediaType;


@end

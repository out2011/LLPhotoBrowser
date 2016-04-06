//
//  ViewController.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "ViewController.h"
#import "LLAssetManager.h"
#import "LLAssetGroup.h"
#import "LLAlbumTableController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /// 获取调用相册时系统提示方法
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                
                LLAlbumTableController *albumTC = [[LLAlbumTableController alloc] init];
                albumTC.browserType = kBrowserAlbum;
                [self.navigationController pushViewController:albumTC animated:YES];
                return;
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            
            NSLog(@"failureBlock");
        }];
    }
    
    LLAlbumTableController *albumTC = [[LLAlbumTableController alloc] init];
    albumTC.browserType = kBrowserAlbum;
    albumTC.mediaType = kMediaTypeNormal;
    [self.navigationController pushViewController:albumTC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

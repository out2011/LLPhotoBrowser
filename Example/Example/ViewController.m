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
    
}

- (IBAction)buttonPressed:(id)sender {
    
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
    albumTC.browserType = kBrowserPlay;
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:albumTC];
    
    [self presentViewController:naVC animated:YES completion:nil];
}


@end

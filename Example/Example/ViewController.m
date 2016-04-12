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
    
    if (iOS8Later) {
        
        [self photoAuthorizationIOS8Later];
    }
    else {
        
        [self photoAuthorizationIOS8Before];
    }
}

- (void)photoAuthorizationIOS8Later {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                [self pushToPhotoController];
            }
        }];
    }
    else {
        
        [self pushToPhotoController];
    }
}

- (void)photoAuthorizationIOS8Before {
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                
                [self pushToPhotoController];
                return;
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            
            NSLog(@"failureBlock");
        }];
    }
    
    else {
        
        [self pushToPhotoController];
    }
}

- (void)pushToPhotoController {
    
    LLAlbumTableController *albumTC = [[LLAlbumTableController alloc] init];
    albumTC.browserType = kBrowserPlay;
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:albumTC];
    
    [self presentViewController:naVC animated:YES completion:nil];
}

@end

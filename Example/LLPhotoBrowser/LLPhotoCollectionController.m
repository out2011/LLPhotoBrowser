
//
//  LLPhotoCollectionController.m
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLPhotoCollectionController.h"
#import "LLAssetCell.h"
#import "LLCancelButton.h"
#import "LLPlayViewController.h"

@interface LLPhotoCollectionController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) BOOL shouldHidden;

@end

@implementation LLPhotoCollectionController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_browserType == kBrowserPlay) {
        
        _shouldHidden = YES;
    }
    
    UIBarButtonItem *cancelBt = [[UIBarButtonItem alloc] init];
    cancelBt.customView = [[LLCancelButton alloc] initWithController:self];
    self.navigationItem.rightBarButtonItem = cancelBt;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLAssetCell" bundle:nil] forCellWithReuseIdentifier:kAssetCellIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (_shouldHidden) {
        
        _shouldHidden = !_shouldHidden;
        
        LLPlayViewController *playVC = [[LLPlayViewController alloc] init];
        playVC.assets = _assets;
        playVC.currentIndex = 0;
        
        [self.navigationController pushViewController:playVC animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dismiss {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collection view data source & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAssetCellIdentifier forIndexPath:indexPath];
    
    [cell configCellWithAsset:_assets[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    LLPlayViewController *playVC = [[LLPlayViewController alloc] init];
    playVC.assets = _assets;
    playVC.currentIndex = indexPath.row;
    
    [self.navigationController pushViewController:playVC animated:YES];
}

@end

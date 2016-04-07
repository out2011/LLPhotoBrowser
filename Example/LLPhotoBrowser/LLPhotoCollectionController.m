
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

@interface LLPhotoCollectionController()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation LLPhotoCollectionController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[LLCancelButton alloc] initWithController:self];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLAssetCell" bundle:nil] forCellWithReuseIdentifier:kAssetCellIdentifier];
    
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

    NSLog(@"%ld", indexPath.row);
}

@end

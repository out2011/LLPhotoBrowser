
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

#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface LLPhotoCollectionController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) BOOL shouldHidden;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, strong) UIView *bottomView;
@end

@implementation LLPhotoCollectionController

- (NSMutableArray *)selectedAssets {
    
    if (_selectedAssets) {
        
        return _selectedAssets;
    }
    return [NSMutableArray array];
}

- (UIView *)bottomView {
    
    if (_bottomView) {
        
        return _bottomView;
    }
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
    _bottomView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSure.frame = CGRectMake(kScreenWidth - 38 -20, 10, 38, 25);
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor colorWithRed:165 / 255.0 green:213 / 255.0 blue:132 / 255.0 alpha:1] forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btnSure];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1];
    [_bottomView addSubview:line];
    
    return _bottomView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_browserType == kBrowserPlay) {
        
        _shouldHidden = YES;
    }
    
    [self.view addSubview:self.bottomView];
    
    UIBarButtonItem *cancelBt = [[UIBarButtonItem alloc] init];
    cancelBt.customView = [[LLCancelButton alloc] initWithController:self];
    self.navigationItem.rightBarButtonItem = cancelBt;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLAssetCell" bundle:nil] forCellWithReuseIdentifier:kAssetCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAssetSelected:) name:@"photoCollectionSelected" object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (_shouldHidden) {
        
        _shouldHidden = !_shouldHidden;
        
        __weak typeof(self) weakSelf = self;
        LLPlayViewController *playVC = [[LLPlayViewController alloc] init];
        playVC.assets = _assets;
        playVC.currentIndex = 0;
        playVC.selectedAssets = _selectedAssets;
        playVC.block = ^(NSArray *selectedAssets) {
            
            _selectedAssets = [selectedAssets mutableCopy];
            [weakSelf.collectionView reloadData];
        };
        
        [self.navigationController pushViewController:playVC animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photoCollectionSelected" object:nil];
}

#pragma mark - button pressed
- (void)sure:(UIButton *)sender {
    
    [[LLAssetManager shareInstance] fillSelectedAssets:_selectedAssets];
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
    playVC.selectedAssets = _selectedAssets;
    playVC.block = ^(NSArray *selectedAssets) {
        
        _selectedAssets = [selectedAssets mutableCopy];
        [collectionView reloadData];
    };
    
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark - notification
- (void)notificationAssetSelected:(NSNotification *)notification {
    
    LLAsset *asset = [notification object];
    asset.isSelected = !asset.isSelected;
    
    if (asset.isSelected) {
        
        [self.selectedAssets addObject:asset];
    }
    else {
        
        [self.selectedAssets removeObject:asset];
    }
}

@end

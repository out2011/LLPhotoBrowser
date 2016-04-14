//
//  LLAlbumTableController.m
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAlbumTableController.h"
#import "LLPhotoCollectionController.h"
#import "LLAlbumCell.h"
#import "LLCancelButton.h"

@interface LLAlbumTableController()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign) BOOL shouldHidden;

@property (nonatomic, strong) NSArray *albums;

@end

@implementation LLAlbumTableController

- (LLAssetManager *)assetManager {
    
    if (_assetManager) {
        return _assetManager;
    }
    _assetManager = [LLAssetManager shareInstance];
    
    return _assetManager;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!_browserType) {
        
        _browserType = kBrowserNormal;
    }
    
    if (_browserType != kBrowserAlbum) {
        
        _shouldHidden = YES;
    }
    
    self.title = @"相册";
    UIBarButtonItem *cancelBt = [[UIBarButtonItem alloc] init];
    cancelBt.customView = [[LLCancelButton alloc] initWithController:self];
    self.navigationItem.rightBarButtonItem = cancelBt;
    
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 70.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLAlbumCell" bundle:nil] forCellReuseIdentifier:kAlbumCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_shouldHidden) {
        
        _shouldHidden = !_shouldHidden;
        
        
        LLPhotoCollectionController *photoCC = [[LLPhotoCollectionController alloc] initWithCollectionViewLayout:[self photoCollectionViewLayoutWithWidth:kScreenSize.width]];
        photoCC.browserType = _browserType;
        photoCC.assets = [self.assetManager allAssetsWithType:_browserType];
        photoCC.title = @"所有照片";
        
        [self.navigationController pushViewController:photoCC animated:NO];
        
    }
    else {
        
        _albums = [self.assetManager allAssetGroups];
        [self.tableView reloadData];
    }
}

- (void)dismiss {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumCellIdentifier];
    
    LLAssetGroup *album = _albums[indexPath.row];
    [cell configWithAssetGroup:album];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LLPhotoCollectionController *photoCC = [[LLPhotoCollectionController alloc] initWithCollectionViewLayout:[self photoCollectionViewLayoutWithWidth:kScreenSize.width]];
    
    LLAssetGroup *album = _albums[indexPath.row];
    
    photoCC.assets = [self.assetManager assetsWithGroup:album type:_browserType];
    photoCC.title = album.name;
    
    [self.navigationController pushViewController:photoCC animated:YES];
}

- (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (width - 2 * margin) / 3;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    return layout;
}
@end

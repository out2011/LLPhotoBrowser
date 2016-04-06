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

@interface LLAlbumTableController()<UITableViewDataSource, UITableViewDelegate>



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
    
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 60.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLAlbumCell" bundle:nil] forCellReuseIdentifier:kAlbumCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (_browserType == kBrowserAlbum) {
        
        _albums = [self.assetManager allAssetGroups];
        [self.tableView reloadData];
    }
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
    
    LLPhotoCollectionController *photoCC = [[LLPhotoCollectionController alloc] initWithCollectionViewLayout:[self photoCollectionViewLayoutWithWidth:self.view.bounds.size.width]];
    
    photoCC.assets = [self.assetManager assetsWithGroup:_albums[indexPath.row] filterType:_mediaType];
    
    [self.navigationController pushViewController:photoCC animated:YES];
}

- (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 6;
    CGFloat itemWH = (width - 3 * margin) / 4;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    return layout;
}
@end

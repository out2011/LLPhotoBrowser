//
//  LLAlbumCell.h
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAssetGroup.h"

#define kAlbumCellIdentifier @"albumCell"

@interface LLAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@property (weak, nonatomic) IBOutlet UILabel *albumName;

- (void)configWithAssetGroup:(LLAssetGroup *)assetGroup;
@end

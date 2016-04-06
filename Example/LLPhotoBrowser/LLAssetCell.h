//
//  LLAssetCell.h
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAsset.h"

#define kAssetCellIdentifier @"assetCell"

@interface LLAssetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

- (void)configCellWithAsset:(LLAsset *)asset;
@end

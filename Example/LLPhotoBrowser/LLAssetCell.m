//
//  LLAssetCell.m
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetCell.h"

@implementation LLAssetCell

- (void)configCellWithAsset:(LLAsset *)asset {
    
    self.thumbnail.image = asset.thumbnail;
}

@end

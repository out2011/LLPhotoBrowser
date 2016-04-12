//
//  LLAssetCell.m
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetCell.h"
@interface LLAssetCell()

@property (nonatomic, strong) LLAsset *asset;

@property (weak, nonatomic) IBOutlet UIButton *btnSelected;

@end

@implementation LLAssetCell


- (void)configCellWithAsset:(LLAsset *)asset {
    
    self.asset = asset;
    self.thumbnail.image = asset.thumbnail;
    if (self.asset.isSelected) {
        
        self.btnSelected.selected = YES;
    }
}

- (IBAction)selected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoCollectionSelected" object:_asset];
}


@end

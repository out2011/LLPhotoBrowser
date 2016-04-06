//
//  LLAlbumCell.m
//  Example
//
//  Created by Lu.L on 16/4/6.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAlbumCell.h"

@implementation LLAlbumCell

- (void)configWithAssetGroup:(LLAssetGroup *)assetGroup {
    
    self.albumName.text = assetGroup.name;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:assetGroup.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",assetGroup.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.albumName.attributedText = nameString;
}

@end

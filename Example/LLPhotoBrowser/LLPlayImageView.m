//
//  LLPlayImageView.m
//  Example
//
//  Created by Lu.L on 16/4/12.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLPlayImageView.h"

@interface LLPlayImageView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;

@end

@implementation LLPlayImageView

- (void)setAsset:(LLAsset *)asset {
    
    _asset = asset;
    _imageView.image = asset.previewImage;
    
    if (_asset.isSelected) {
        
        _btnSelected.selected = YES;
    }
}

- (IBAction)selectedAsset:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playAssetSelected" object:_asset];
}

@end

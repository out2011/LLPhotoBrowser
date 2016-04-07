//
//  LLCancelButton.m
//  Example
//
//  Created by Lu.L on 16/4/7.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLCancelButton.h"

@interface LLCancelButton()

@property (nonatomic, strong) UIViewController *controller;

@end

@implementation LLCancelButton

- (instancetype)initWithController:(UIViewController *)controller {
    
    self = [super init];
    
    _controller = controller;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,38,25)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.customView = rightButton;
    
    return self;
}

- (void)dismiss {
    
    [_controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

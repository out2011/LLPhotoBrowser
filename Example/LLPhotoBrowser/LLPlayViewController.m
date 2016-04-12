//
//  LLPlayViewController.m
//  Example
//
//  Created by Lu.L on 16/4/7.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLPlayViewController.h"
#import "LLAssetManager.h"
#import "LLCancelButton.h"
#import "LLPlayImageView.h"

@interface LLPlayViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *customNavigationBar;

@property (nonatomic, assign) NSInteger scrollIndex;

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation LLPlayViewController

- (UIScrollView *)scrollView {
    
    if (_scrollView) {
        return _scrollView;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _assets.count, 0);
    _scrollView.contentOffset = CGPointMake(kScreenWidth * _currentIndex, 0);
    _scrollIndex = _scrollView.contentOffset.x / kScreenWidth;
    
    return _scrollView;
}

- (UIView *)customNavigationBar {
    
    if (_customNavigationBar) {
        return _customNavigationBar;
    }
    
    _customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _customNavigationBar.backgroundColor = [UIColor whiteColor];
    _customNavigationBar.alpha = 0.95;
    
    LLCancelButton *cancelBt = [[LLCancelButton alloc] initWithController:self];
    cancelBt.frame = CGRectMake(kScreenWidth - 35 - 20, 30, 38, 25);
    [_customNavigationBar addSubview:cancelBt];
    
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBt.frame = CGRectMake(4, 30, 54, 25);
    [backBt setTitle:@"<照片" forState:UIControlStateNormal];
    [backBt setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_customNavigationBar addSubview:backBt];
    
    return _customNavigationBar;
}

- (NSMutableArray *)imageViews {
    
    if (_imageViews) {
        return _imageViews;
    }
    
    _imageViews = [NSMutableArray array];
    return _imageViews;
}

#pragma mark - interface
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedAssets = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.customNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAssetSelected:) name:@"playAssetSelected" object:nil];
    
    [self addImageViews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!_selectedAssets) {
        
        _selectedAssets = [NSMutableArray array];
    }
}

- (void)addImageViews {
    
    [self initImageViewWithIndex:_currentIndex - 1];
    [self initImageViewWithIndex:_currentIndex];
    [self initImageViewWithIndex:_currentIndex + 1];
}

- (void)initImageViewWithIndex:(NSInteger)index {
    
    if (index < 0 || index > _assets.count - 1) {
        
        return;
    }
    
    LLAsset *asset = _assets[index];
    
    LLPlayImageView *imageView = [[[NSBundle mainBundle] loadNibNamed:@"LLPlayImageView" owner:self options:nil] lastObject];
    imageView.frame = CGRectMake(kScreenWidth * index, 0, kScreenWidth, kScreenHeight);
    imageView.asset = asset;
    
    if (index < _currentIndex) {
        
        [self.imageViews insertObject:imageView atIndex:0];
    }
    else {
        
        [self.imageViews addObject:imageView];
    }
    
    [self.scrollView addSubview:imageView];
    
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger newIndex = scrollView.contentOffset.x / kScreenWidth;
    if (newIndex > _scrollIndex) {
        
        _currentIndex++;
        [self initImageViewWithIndex:_currentIndex + 1];
    }
    else if (newIndex < _scrollIndex) {
        
        _currentIndex--;
        [self initImageViewWithIndex:_currentIndex - 1];
    }
}

#pragma mark - button pressed
- (void)back {
    
    if (self.block) {
        
        _block(_selectedAssets);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - notification 
- (void)notificationAssetSelected:(NSNotification *)notification {
    
    LLAsset *asset = [notification object];
    asset.isSelected = !asset.isSelected;
    
    if (asset.isSelected) {
        
        [_selectedAssets addObject:asset];
    }
    else {
        
        [_selectedAssets removeObject:asset];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playAssetSelected" object:nil];
}
@end

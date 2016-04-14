//
//  LLAssetManager.m
//  Example
//
//  Created by Lu.L on 16/4/1.
//  Copyright © 2016年 L.l. All rights reserved.
//

#import "LLAssetManager.h"
#import "LLAsset.h"
#import "LLAssetGroup.h"

static LLAssetManager *assetManager = nil;

@interface LLAssetManager()

@property (nonatomic, strong) NSArray *selectedAssets;

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetGroups;

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@end

@implementation LLAssetManager

+ (LLAssetManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        assetManager = [[LLAssetManager alloc] init];
    });
    return assetManager;
}

- (void)loadAssets {
    
    _assets = [NSMutableArray array];
    _assetGroups = [NSMutableArray array];
    if (iOS8Later) {
        
        [self iOS8LaterLoadAssets];
    }
    else {
        
        [self iOS8BeforeLoadAssets];
    }
}

/// iOS8后访问相册  access photo album after iOS 8
- (void)iOS8LaterLoadAssets {
    
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
    // For iOS 9, We need to show ScreenShots Album && SelfPortraits Album
    if (iOS9Later) {
        smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"]) continue;
        
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [_assetGroups insertObject:[LLAssetGroup groupWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [_assetGroups addObject:[LLAssetGroup groupWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
            [_assetGroups insertObject:[LLAssetGroup groupWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
        } else {
            [_assetGroups addObject:[LLAssetGroup groupWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    
    PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
    [fetchResults enumerateObjectsUsingBlock:^(id asset, NSUInteger idx, BOOL *stop) {
        
        [_assets addObject:[LLAsset assetWithItem:asset]];
    }];
}

/// iOS8前访问相册  access photo album before iOS 8
- (void)iOS8BeforeLoadAssets {
    
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    
    NSMutableArray *assetGroups = [NSMutableArray array];
    NSMutableArray *assetURLDictionaries = [NSMutableArray array];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            NSString *assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                NSURL *url = result.defaultRepresentation.url;
                [_assetLibrary assetForURL:url
                               resultBlock:^(ALAsset *asset) {
                                   if (asset) {
                                       
                                       [_assets addObject:[LLAsset assetWithItem:asset]];
                                   }
                               }
                              failureBlock:^(NSError *error){
                                  NSLog(@"error: %s", __FUNCTION__);
                              }];
            }
        }
    };
    
    void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            LLAssetGroup *assetGroup = [LLAssetGroup groupWithResult:group name:name];
            [assetGroups addObject:assetGroup];
        }
    };
    
    [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                 usingBlock:assetGroupEnumerator
                               failureBlock:^(NSError *error) {
                                   NSLog(@"error: %s", __FUNCTION__);
                               }];
}

- (NSArray *)allAssetsWithType:(LLBrowserType)type {
    
    [self loadAssets];
    LLMediaType mediaType = [self mediaTypeWithBrowserType:type];
    if (mediaType == kMediaTypeNormal) {
        return _assets;
    }
    return [self filterAssets:_assets withType:mediaType];
}

- (NSArray *)allAssetGroups {
    
    [self loadAssets];
    return _assetGroups;
}

- (NSArray *)assetsWithGroup:(id)group type:(LLBrowserType)type {
    
    LLAssetGroup *album = (LLAssetGroup *)group;
    
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([album.fetchResult isKindOfClass:[PHFetchResult class]]) {
        for (PHAsset *asset in album.fetchResult) {
            
            [photoArr addObject:[LLAsset assetWithItem:asset]];
        }
    } else if ([album.fetchResult isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *assetGruop = (ALAssetsGroup *)album.fetchResult;
        
        [assetGruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            [photoArr addObject:[LLAsset assetWithItem:result]];
        }];
    }
    
    LLMediaType mediaType = [self mediaTypeWithBrowserType:type];
    if (mediaType == kMediaTypeNormal) {
        return photoArr;
    }
    return [self filterAssets:photoArr withType:mediaType];
}

- (NSArray *)filterAssets:(NSArray *)assets withType:(LLMediaType)type {
    
    if (type == kMediaTypeNormal) {
        
        return assets;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < assets.count; i++) {
        
        LLAsset *asset = assets[i];
        if (asset.mediaType == type) {
            
            [result addObject:asset];
        }
    }
    return [result copy];
}

- (LLMediaType)mediaTypeWithBrowserType:(LLBrowserType)browserType {
    
    if (browserType == kBrowserPhoto) {
        
        return kMediaTypePhoto;
    }
    else if (browserType == kBrowserVideo) {
        
        return kMediaTypeVideo;
    }
    else {
        
        return kMediaTypeNormal;
    }
}

- (void)fillSelectedAssets:(NSMutableArray *)assets {
    
    _selectedAssets = [assets copy];
}
@end

//
//  ALAssetsLibraryTest.m
//  RollToEver
//
//  Created by fifnel on 2013/02/09.
//  Copyright 2013年 fifnel. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
//#import <OCMock/OCMock.h>
#import "ALAssetsLibrary+BlockingUtility.h"
#import "AssetURLStorage.h"
 
@interface ALAssetsLibraryTest : GHTestCase { }
@end
 
@implementation ALAssetsLibraryTest
{
    __strong ALAssetsLibrary *_assetsLibrary;
}

//Method called before each tests
- (void) setUp
{
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
}

//Method called before after each tests
- (void) tearDown
{
}

- (void)testALAssetLibraryBlockingUtility
{
    NSArray *list = [_assetsLibrary assetsURLList];
    GHAssertNotNil(list, @"asset list enumerate failure");
    GHAssertGreaterThan((int)[list count], 0, @"list is empty");

    {
        NSString *url = [list objectAtIndex:0];
        ALAsset *asset = [_assetsLibrary loadAssetFromURLString:url];
        GHAssertNotNil(asset, @"asset load failure");
    }

    {
        NSArray *list = [_assetsLibrary assetsURLList];
        NSString *urlStr = [list objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:urlStr];
        ALAsset *asset = [_assetsLibrary loadAssetFromURL:url];
        GHAssertNotNil(asset, @"asset load failure");
    }
}

- (void)testFilterdAssetURLList
{
    NSArray *list = [_assetsLibrary assetsURLList];

    AssetURLStorage *storage = [[AssetURLStorage alloc] init];
    
    [storage deleteAllURLs];

    NSArray *preFilterdList = [_assetsLibrary filteredAssetsURLList];
    
    __block NSString *excludeURL = [list objectAtIndex:0];
    [storage insertURL:excludeURL];

    NSArray *postFilterdList = [_assetsLibrary filteredAssetsURLList];
    
    GHAssertEquals([preFilterdList count], [postFilterdList count]+1, @"filter is not work");
}

@end
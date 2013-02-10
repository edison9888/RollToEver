//
//  ALAssertTest.m
//  RollToEver
//
//  Created by fifnel on 2013/02/03.
//  Copyright 2013年 fifnel. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
//#import <OCMock/OCMock.h>
#import "ALAssetTestUtility.h"
 
@interface ALAssetTestUtilityTest : GHTestCase
{
    __strong ALAssetTestUtility *_assetsUtility;
}
@end
 
@implementation ALAssetTestUtilityTest

//Method called before each tests
- (void) setUp
{
    _assetsUtility = [[ALAssetTestUtility alloc] init];
}

//Method called before after each tests
- (void) tearDown
{
    
} 
 
- (void)testGetJpeg {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"jpg"];
    GHAssertNotNil(asset, @"jpeg not found");
}

- (void)testGetGif {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"gif"];
    GHAssertNotNil(asset, @"gif not found");
}

- (void)testGetPng {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"png"];
    GHAssertNotNil(asset, @"png not found");
}

- (void)testGetJpg2000 {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"jp2"];
    GHAssertNotNil(asset, @"jpeg2000 not found");
}

- (void)testGetTiff {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"tif"];
    GHAssertNotNil(asset, @"tiff not found");
}

- (void)testGetUnknown {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@"hoge"];
    GHAssertNil(asset, @"unknown(hoge) asset found");
}

- (void)testGetNil {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:nil];
    GHAssertNil(asset, @"unknown(nil) assset found");
}

- (void)testGetEmpty {
    ALAsset *asset = [_assetsUtility getFirstAssertByExtension:@""];
    GHAssertNil(asset, @"unknown(empty) asset found");
}

@end
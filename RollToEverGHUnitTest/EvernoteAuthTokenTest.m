//
//  EvernoteAuthTokenTest.m
//  RollToEver
//
//  Created by fifnel on 2012/02/25.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "EvernoteAuthTokenTest.h"
#import "UserSettings.h"
#import "id.h"
#import <GHUnitIOS/GHUnit.h>
#import "SettingsTableViewController.h"
#import "AssetsLoader.h"
#import "ALAsset+Evernote.h"

@implementation EvernoteAuthTokenTest

- (void)setUpClass {
}

- (void)tearDownClass {
    
}

- (void)setUp {
}

- (void)tearDown {
}

- (void)testAlAsset {
    AssetsLoader *al = [[AssetsLoader alloc] init];
    NSArray *assetList = [al EnumerateURLExcludeDuplication:NO];
    for(NSString *url in assetList) {
        NSLog(@"%@", url);
        ALAsset *asset = [al loadAssetURLString:url];
        EDAMNote *note = [asset createEDAMNote:@"GUID" photoSize:0];
        NSLog(@"%@", note);
    }
}


- (void)testEvernoteAuthToken {
    /*
    NSLog(@"1111");
    EvernoteUserStoreClient *userClient = [[EvernoteUserStoreClient alloc] initWithDelegate:nil];
    EDAMAccounting *accounting = [[userClient.userStoreClient getUser:[EvernoteAuthToken sharedInstance].authToken] accounting];
    
    NSLog(@"2222");7
    EvernoteNoteStoreClient *noteClient = [[EvernoteNoteStoreClient alloc] initWithDelegate:nil];
    EDAMSyncState *syncStatus = [noteClient.noteStoreClient getSyncState:[EvernoteAuthToken sharedInstance].authToken];
    
    NSLog(@"--------%lld / %lld", syncStatus.uploaded/1024, accounting.uploadLimit/1024);
     */
}

- (void)testEvernoteUserStore {
    /*
    EvernoteUserStoreClient *userClient = [[EvernoteUserStoreClient alloc] initWithDelegate:nil];
    EDAMAccounting *accounting = [[userClient.userStoreClient getUser:[EvernoteAuthToken sharedInstance].authToken] accounting];
    GHAssertTrue([accounting uploadLimitIsSet], @"upload limit not set");
    NSLog(@"----upload limit:%lld", [accounting uploadLimit]);
     */
}

- (void)testEvernoteNoteStore {
    /*
    EvernoteNoteStoreClient *noteClient = [[EvernoteNoteStoreClient alloc] initWithDelegate:nil];
    EDAMSyncState *syncStatus = [noteClient.noteStoreClient getSyncState:[EvernoteAuthToken sharedInstance].authToken];
    GHAssertTrue([syncStatus uploadedIsSet], @"uploaded not set");
    NSLog(@"----uploaded:%lld", [syncStatus uploaded]);
     */
}

@end

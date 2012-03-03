//
//  EvernoteNoteStoreClient.m
//  RollToEver
//
//  Created by fifnel on 2012/02/25.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "EvernoteNoteStoreClient.h"
#import "EvernoteAuthToken.h"
#import "THTTPAsyncClient.h"
#import "TBinaryProtocol.h"
#import "NoteStore.h"
#import "id.h"

static NSString * const noteStoreUriBase = @"https://sandbox.evernote.com/edam/note/"; 

@interface EvernoteNoteStoreClient ()

@property (retain, readwrite) EDAMNoteStoreClient *noteStoreClient;

@end

@implementation EvernoteNoteStoreClient

@synthesize noteStoreClient = noteStoreClient_;

- (id)init
{
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        // URL作成
        NSString *shardId = [EvernoteAuthToken sharedInstance].shardId;
        NSString *urlString = [NSString stringWithFormat:@"%@%@", noteStoreUriBase, shardId];
        NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
        
        // UserAgent作成
        UIDevice *device = [UIDevice currentDevice];
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@;%@(%@)/%@",
                               APPLICATIONNAME,
                               APPLICATIONVERSION,
                               [device systemName],
                               [device model],
                               [device systemVersion]]; 

        // クライアントの初期化
        THTTPAsyncClient *httpClient = [[[THTTPAsyncClient alloc] initWithURL:url userAgent:userAgent timeout:15000] autorelease];
        httpClient.delegate = delegate;
        TBinaryProtocol *protocol = [[[TBinaryProtocol alloc] initWithTransport:httpClient] autorelease];
        noteStoreClient_ = [[EDAMNoteStoreClient alloc] initWithProtocol:protocol];
    }
    return self;
}

- (void)dealloc
{
    self.noteStoreClient = nil;
    [super dealloc];
}

@end

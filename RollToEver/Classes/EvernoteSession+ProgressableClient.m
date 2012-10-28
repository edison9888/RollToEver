//
//  EvernoteSession+ProgressableClient.m
//  RollToEver
//
//  Created by fifnel on 2012/09/15.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "Config.h"

#import "EvernoteSession+ProgressableClient.h"
#import "Thrift.h"
#import "THTTPAsyncClient.h"

@implementation EvernoteSession (ProgressableClient)

- (NSString *)getUserAgent
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@;%@(%@)/%@",
                                                     APPLICATION_NAME,
                                                     APPLICATION_VERSION,
                                                     [device systemName],
                                                     [device model],
                                                     [device systemVersion]];

    return userAgent;
}

- (EDAMNoteStoreClient *)noteStoreWithDelegate:(id)delegate
{
    NSURL *url = [NSURL URLWithString:[self noteStoreUrl]];
    THTTPAsyncClient *httpClient = [[[THTTPAsyncClient alloc] initWithURL:url userAgent:[self getUserAgent] timeout:15000] autorelease];
    httpClient.delegate = delegate;
    TBinaryProtocol *protocol = [[[TBinaryProtocol alloc] initWithTransport:httpClient] autorelease];
    return [[[EDAMNoteStoreClient alloc] initWithProtocol:protocol] autorelease];
}

- (EDAMUserStoreClient *)userStoreWithDelegate:(id)delegate
{
    NSURL *url = [NSURL URLWithString:[self userStoreUrl]];
    THTTPAsyncClient *httpClient = [[[THTTPAsyncClient alloc] initWithURL:url userAgent:[self getUserAgent] timeout:15000] autorelease];
    httpClient.delegate = delegate;
    TBinaryProtocol *protocol = [[[TBinaryProtocol alloc] initWithTransport:httpClient] autorelease];
    return [[[EDAMUserStoreClient alloc] initWithProtocol:protocol] autorelease];
}

@end

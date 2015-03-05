//
//  OTRMediaServer.m
//  ChatSecure
//
//  Created by David Chiles on 2/24/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import "OTRMediaServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerRequest.h"
#import "GCDWebServerVirtualFileResponse.h"
#import "OTRMediaFileManager.h"

@interface OTRMediaServer ()

@property (nonatomic, strong) GCDWebServer *webServer;

@end

@implementation OTRMediaServer

- (instancetype)init{
    if (self = [super init]) {
        self.webServer = [[GCDWebServer alloc] init];
    }
    return self;
}

- (IOCipher *)ioCipher
{
    return [OTRMediaFileManager sharedInstance].ioCipher;
}

- (void)startOnPort:(NSUInteger)port error:(NSError **)error
{
    if (!(port > 0)) {
        port = 8080;
    }
    __weak typeof(self)weakSelf = self;
    [self.webServer startWithOptions:@{GCDWebServerOption_Port: @(port),
                                       GCDWebServerOption_BindToLocalhost: @(YES),
                                       GCDWebServerOption_AutomaticallySuspendInBackground: @(NO)}
                               error:error];
    [self.webServer addHandlerForMethod:@"GET"
                              pathRegex:[NSString stringWithFormat:@"/%@/.*",kOTRRootMediaDirectory]
                           requestClass:[GCDWebServerRequest class]
                      asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
                          __strong typeof(weakSelf)strongSelf = weakSelf;
                          [strongSelf handleMediaRequest:request completion:completionBlock];
                      }];
}

- (void)handleMediaRequest:(GCDWebServerRequest *)request completion:(GCDWebServerCompletionBlock)completionBlock
{
    if (completionBlock) {
        NSLog(@"Server Request: %@",request);
        GCDWebServerVirtualFileResponse *virtualFileResponse = [GCDWebServerVirtualFileResponse responseWithFile:request.path
                                                                                                       byteRange:request.byteRange
                                                                                                    isAttachment:NO
                                                                                                        ioCipher:[self ioCipher]];
        [virtualFileResponse setValue:@"bytes" forAdditionalHeader:@"Accept-Ranges"];
        completionBlock(virtualFileResponse);
    }
}

- (NSURL *)urlForMediaItem:(OTRMediaItem *)mediaItem buddyUniqueId:(NSString *)buddyUniqueId
{
    NSString *itemPath = [OTRMediaFileManager pathForMediaItem:mediaItem buddyUniqueId:buddyUniqueId];
    NSString *path = [[NSString stringWithFormat:@"http://localhost:%lu",(unsigned long)self.webServer.port] stringByAppendingPathComponent:itemPath];
    return [NSURL URLWithString:path];
}

#pragma - mark Class Methods

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end

//
//  STLocalServer.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STLocalServer.h"
#import <STKit/STKit.h>

@interface STLocalServer ()

//@property (nonatomic, strong) HTTPServer * server;

@end

@implementation STLocalServer
static STLocalServer * _defaultLocalServer;
+ (instancetype) defaultLocalServer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLocalServer = STLocalServer.new;
    });
    return _defaultLocalServer;
}

- (instancetype) init {
    self = [super init];
    if (self) {
//        self.server = [[HTTPServer alloc] init];
        // Tell the server to broadcast its presence via Bonjour.
        // This allows browsers such as Safari to automatically discover our service.
//        self.server.type = @"_http._tcp.";
        
        // Normally there's no need to run our server on any specific port.
        // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
        // However, for easy testing you may want force a certain port so you can just hit the refresh button.
//        self.server.port = 12345;
        // Serve files from our embedded Web folder
        NSString * home = STDocumentDirectory();
        NSString * indexHTML = @"<html>\
        <head>\
        </head>\
        <body>\
        Hello, World, This is local Server\
        </body>\
        </html>";
        NSString * indexPath = [home stringByAppendingPathComponent:@"/index.html"];
        [indexHTML writeToFile:indexPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        self.server.documentRoot = home;
    }
    return self;
}


- (void) start {
//    [self.server start:nil];
}

- (void) stop {
//    [self.server stop:YES];
}
@end

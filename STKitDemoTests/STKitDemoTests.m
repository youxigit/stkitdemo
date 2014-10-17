//
//  STKitDemoTests.m
//  STKitDemoTests
//
//  Created by SunJiangting on 14-8-31.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <STKit/STKit.h>

@interface STKitDemoTests : XCTestCase

@end

@implementation STKitDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHTTPNetwork {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    STHTTPNetwork * network = [[STHTTPNetwork alloc] initWithHost:@"www.lovecard.sinaapp.com" path:@"open"];
    [network sendAsynchronousRequestWithMethod:@"photo/list" HTTPMethod:@"GET" parameters:@{@"page":@(1), @"size":@(5)} handler:^(NSHTTPURLResponse *response, id data, NSError *error) {
        NSLog(@"response:%@;data:%@;error:%@", response, data, error);
        CFRunLoopStop(runLoop);
    }];
    CFRunLoopRun();
}

- (void) testHTTPNetworkNoHost {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    STHTTPNetwork * network = [[STHTTPNetwork alloc] initWithHost:nil path:@"open"];
    [network sendAsynchronousRequestWithMethod:@"photo/list" HTTPMethod:@"GET" parameters:@{@"page":@(1), @"size":@(5)} handler:^(NSHTTPURLResponse *response, id data, NSError *error) {
        NSLog(@"response:%@;data:%@;error:%@", response, data, error);
        CFRunLoopStop(runLoop);
    }];
    CFRunLoopRun();
}

@end

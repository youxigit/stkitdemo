//
//  STHTTPNetwork.h
//  STKit
//
//  Created by SunJiangting on 13-11-25.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/Foundation+STKit.h>
#import <Foundation/Foundation.h>
#import "STNetworkConfiguration.h"

@class STHTTPOperation;
typedef void (^STHTTPNetworkHandler)(STHTTPOperation *operation, id response, NSError *error);
typedef void (^STHTTPSynchronousNetworkHandler)(NSURLResponse *response, id data, NSError *error);

/// HTTP类型的网络请求
@interface STHTTPNetwork : NSObject

+ (instancetype)defaultHTTPNetwork;

- (instancetype)initWithConfiguration:(STNetworkConfiguration *)configuration;
/// default mainQueue
@property(nonatomic, strong) dispatch_queue_t   callbackQueue;
@property(nonatomic, assign) NSInteger          maxConcurrentRequestCount;


- (void)sendHTTPOperation:(STHTTPOperation *)operation;

- (void)cancelHTTPOperation:(STHTTPOperation *)operation;

@end

@interface STHTTPNetwork (STHTTPConvenience)

- (void)sendHTTPOperation:(STHTTPOperation *)operation
        completionHandler:(STHTTPNetworkHandler)completionHandler;

@end

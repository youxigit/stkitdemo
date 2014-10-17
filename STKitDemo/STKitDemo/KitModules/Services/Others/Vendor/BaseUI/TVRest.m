//
//  TVRest.m
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVRest.h"

#import <STKit/STKit.h>

@interface TVRest ()

@property (nonatomic, strong) STHTTPNetwork * restNetwork;

@end

@implementation TVRest

+ (instancetype) defaultRest {
    static TVRest * _rest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rest = TVRest.new;
    });
    return _rest;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.restNetwork = [[STHTTPNetwork alloc] initWithHost:@"http://authorized.duapp.com" path:@"vendor"];
        self.restNetwork.HTTPMethod = @"POST";
    }
    return self;
}

- (void) fetchProductionWithPageSize:(NSInteger) pageSize
                          pageNumber:(NSInteger) pageNumber
                             handler:(void (^)(STNetworkOperation * operation, id response, NSError *)) handler {
    if (pageSize == 0) {
        pageSize = 20;
    }
    NSDictionary * params = @{@"pageSize":@(pageSize), @"page":@(pageNumber)};
    [self.restNetwork sendAsynchronousRequestWithMethod:@"products.action" parameters:params handler:handler];
}

- (void) uploadFileToDefaultPath:(NSString *) filePath handler:(void(^)(STNetworkOperation * operation, id response, NSError *)) handler {
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if (data.length == 0) {
        return;
    }
    STPostDataItem * item = [[STPostDataItem alloc] init];
    item.data = data;
    item.name = @"12345";
    item.path = filePath;
    [self.restNetwork sendAsynchronousRequestWithMethod:@"upload.action" parameters:@{@"product":item} handler:handler];
}

- (void) publishProductWithName:(NSString *) name
                          title:(NSString *) title
                       imageIds:(NSString *) imageIds
                        handler:(void(^)(STNetworkOperation *, id, NSError *)) handler {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setValue:name.length > 0 ? name : @"测试产品" forKey:@"name"];
    [params setValue:title forKey:@"title"];
    [params setValue:imageIds forKey:@"imageIds"];
    [params setValue:@"北京" forKey:@"province"];
    [params setValue:@"朝阳" forKey:@"city"];
    [self.restNetwork sendAsynchronousRequestWithMethod:@"publish.action" parameters:params handler:handler];
}

@end

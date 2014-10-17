//
//  TVRest.h
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/STKit.h>

@interface TVRest : NSObject

+ (instancetype) defaultRest;

- (void) fetchProductionWithPageSize:(NSInteger) pageSize
                          pageNumber:(NSInteger) pageNumber
                             handler:(void (^)(STNetworkOperation * operation, id response, NSError *)) handler;

- (void) uploadFileToDefaultPath:(NSString *) filePath handler:(void(^)(STNetworkOperation * operation, id response, NSError *)) handler ;

- (void) publishProductWithName:(NSString *) name
                          title:(NSString *) title
                       imageIds:(NSString *) imageIds
                        handler:(void(^)(STNetworkOperation *, id, NSError *)) handler;
@end

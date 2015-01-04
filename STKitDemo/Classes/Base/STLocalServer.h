//
//  STLocalServer.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STLocalServer : NSObject

+ (instancetype) defaultLocalServer;

- (void) start;
- (void) stop;

@end

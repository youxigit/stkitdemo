//
//  STDFactoryPatterns.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDesignPatterns.h"

@protocol STDCompanyProtocol;
/// 这个只是一些前置条件的准备
@interface STDFactoryPatterns : NSObject

@end


@protocol STDCompanyProtocol <NSObject>

- (void)printCompanyName;

@end


@interface STDCompanyApple : NSObject <STDCompanyProtocol>


@end

@interface STDCompanyGoogle : NSObject <STDCompanyProtocol>


@end
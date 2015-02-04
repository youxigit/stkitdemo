//
//  STDFactory.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDFactory.h"


@implementation STDFactory
+ (void)test {
    id<STDCompanyProtocol> appleFactory = [STDAppleFactory createCompany];
    [appleFactory printCompanyName];
    
    id<STDCompanyProtocol> googleFactory = [STDGoogleFactory createCompany];
    [googleFactory printCompanyName];
}

+ (id <STDCompanyProtocol>)createCompany {
    return nil;
}

- (void)printDesignPatternName {
    NSLog(@"工厂模式");
}

- (void)printAdvantages {
    
}

- (void)printDisadvantages {
    
}
@end

@implementation STDAppleFactory
+ (id <STDCompanyProtocol>)createCompany {
    return STDCompanyApple.new;
}
@end

@implementation STDGoogleFactory
+ (id <STDCompanyProtocol>)createCompany {
    return STDCompanyGoogle.new;
}
@end
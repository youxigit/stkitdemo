//
//  STDesignPatterns.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STDesignPatternsDelegate <NSObject>

+ (void)test;

@optional
- (void)printDesignPatternName;
- (void)printAdvantages;
- (void)printDisadvantages;

@end

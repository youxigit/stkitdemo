//
//  STBWindow.h
//  STKitDemo
//
//  Created by SunJiangting on 14-10-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBLoader : NSObject

+ (instancetype)defaultLoader;

- (void)loadBoxManAnimated:(BOOL)animated;
- (void)unloadBoxManAnimated:(BOOL)animated;

@end

@interface STBWindow : UIWindow

@end

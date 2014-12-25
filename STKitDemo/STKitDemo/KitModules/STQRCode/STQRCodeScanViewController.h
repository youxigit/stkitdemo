//
//  STQRCodeScanViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 14-2-20.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/STKit.h>

@interface STQRCodeScanViewController : STViewController
@property (nonatomic, assign) BOOL  continueWhenScaned;
@property (nonatomic, strong) void(^scanCompletionHandler)(STQRCodeScanViewController *viewController, NSString *result, NSError *error);

- (void)dismissAnimated:(BOOL)animated;

@end

//
//  STDAppDelegate.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-6.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STDVoiceWindow.h"

@class SCSiriWaveformView;
@interface STDAppDelegate : UIResponder <UIApplicationDelegate>
+ (BOOL)boxManEnabled;
+ (BOOL)sinaappCorrectionEnabled;
+ (void)displayNotificationWithName:(NSString *) name title:(NSString *) title;

@property (strong, nonatomic) UIWindow        * window;

@property (nonatomic, strong) SCSiriWaveformView    * wavefromView;
@property (nonatomic, strong) STDVoiceWindow  * voiceWindow;

- (UIViewController *) startViewController;
- (UIViewController *) tabBarController;
- (UIViewController *) sideBarController;
- (void) replaceRootViewController:(UIViewController *)newViewController
                  animationOptions:(UIViewAnimationOptions) options;

- (void)displayNotificationWithName:(NSString *) name title:(NSString *) title;

@end

extern NSString * const STDVoiceRecognizerNotification;
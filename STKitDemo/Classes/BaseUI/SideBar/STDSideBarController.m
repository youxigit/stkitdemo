//
//  STDSideBarController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-11-20.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDSideBarController.h"
#import "STARootViewController.h"

#import "STDChatViewController.h"

#import "STDMoreViewController.h"
#import "STDTabBarController.h"
#import "STDMapViewController.h"
#import "STDemoViewController.h"
#import "STDServiceViewController.h"

@interface STDSideBarController ()

@end

@implementation STDSideBarController

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        STDMapViewController * mapViewController = STDMapViewController.new;
        STNavigationController * mapNavigationController = [[STNavigationController alloc] initWithRootViewController:mapViewController];
        
        STDemoViewController * controlsViewController = [[STDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * controlsNavigationController = [[STNavigationController alloc] initWithRootViewController:controlsViewController];
        
        STDServiceViewController * serviceViewController = [[STDServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * serviceNavigationController = [[STNavigationController alloc] initWithRootViewController:serviceViewController];
        
        STDMoreViewController * moreViewController = [[STDMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * moreNavigationController = [[STNavigationController alloc] initWithRootViewController:moreViewController];
        
        self.viewControllers = @[mapNavigationController, controlsNavigationController, serviceNavigationController, moreNavigationController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceDidRecognizerText:) name:@"STDVoiceRecognizerNotification" object:nil];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STDVoiceRecognizerNotification" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) voiceDidRecognizerText:(NSNotification *) notification {
    NSString * text = [notification.userInfo valueForKey:@"text"];
    BOOL responds = YES;
    if ([self.selectedViewController respondsToSelector:@selector(viewControllers)]) {
        responds = ((STNavigationController *) self.selectedViewController).viewControllers.count == 1;
    }
    if (responds) {
        if ([text contains:@"侧边"] || [text contains:@"窗帘"]) {
            if ([text contains:@"打开"]) {
                if (!self.sideAppeared) {
                    [self revealSideViewControllerAnimated:YES];
                }
            } else if ([text contains:@"关闭"]) {
                if (self.sideAppeared) {
                    [self concealSideViewControllerAnimated:YES];
                }
            }
        }
    }
}

@end

    //
//  STDTabBarController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-2-18.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTabBarController.h"
#import "STARootViewController.h"
#import "STDMoreViewController.h"
#import "STDemoViewController.h"
#import "STDServiceViewController.h"
#import "STDSettingViewController.h"

@interface STDTabBarController ()

@end

@implementation STDTabBarController

- (void) dealloc {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        STDemoViewController * controlsViewController = [[STDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * controlsNavigationController = [[STNavigationController alloc] initWithRootViewController:controlsViewController];
        controlsNavigationController.customTabBarItem = [[STTabBarItem alloc] initWithTitle:@"组件" image:[UIImage imageNamed:@"tab_receipt_normal.png"] selectedImage:[UIImage imageNamed:@"tab_receipt_highlighted.png"]];
        
        STDServiceViewController * serviceViewController = [[STDServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * serviceNavigationController = [[STNavigationController alloc] initWithRootViewController:serviceViewController];
        serviceNavigationController.customTabBarItem = [[STTabBarItem alloc] initWithTitle:@"服务" image:[UIImage imageNamed:@"tab_service_normal.png"] selectedImage:[UIImage imageNamed:@"tab_service_highlighted.png"]];
        
        STDMoreViewController * moreViewController = [[STDMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController * moreNavigationController = [[STNavigationController alloc] initWithRootViewController:moreViewController];
        moreNavigationController.customTabBarItem = [[STTabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tab_profile_normal.png"] selectedImage:[UIImage imageNamed:@"tab_profile_highlighted.png"]];
        self.viewControllers = @[controlsNavigationController, serviceNavigationController, moreNavigationController];
        
        self.sideInteractionArea = STSideInteractiveAreaNone;
        self.animatedWhenTransition = ![STDSettingViewController reduceTransitionAnimation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (STGetSystemVersion() < 7) {
        self.actualTabBarHeight = 42;
        self.tabBar.backgroundImage = [[UIImage imageNamed:@"tab_bkg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 2, 10, 2) resizingMode:UIImageResizingModeStretch];
    }
    if (![[[STPersistence standardPersistence] valueForKey:@"STHasEnteredAboutViewController"] boolValue]) {
        [self setBadgeValue:@"New" forIndex:2];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) voiceDidRecognizerText:(NSNotification *) notification {
    NSString * text = [notification.userInfo valueForKey:@"text"];
    if (self.tabBar.hidden) {
        return;
    }
    if ([text contains:@"第一个标签"]) {
        self.selectedIndex = 0;
    } else if ([text contains:@"第二个标签"]) {
        self.selectedIndex = 1;
    }  else if ([text contains:@"第三个标签"]) {
        self.selectedIndex = 2;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

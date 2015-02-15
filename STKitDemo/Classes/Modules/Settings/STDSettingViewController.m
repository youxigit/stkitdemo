//
//  STDSettingViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-15.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDSettingViewController.h"
#import "STDNavigationSettingViewController.h"

@interface STDSettingViewController ()

@end

@implementation STDSettingViewController

+ (BOOL)allowsCustomNavigationTransition {
    return [[[STPersistence standardPerstence] valueForKey:@"STDAllowsCustomNavigationTransition"] boolValue];
}

+ (BOOL)chatReceiveImage {
   return [[[STPersistence standardPerstence] valueForKey:@"STDChatAcceptImage"] boolValue];
}

+ (BOOL)reduceTransitionAnimation {
   return [[[STPersistence standardPerstence] valueForKey:@"STDReduceTransitionAnimation"] boolValue];
}

- (instancetype)initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];
        STDTableViewCellItem * item00 = [[STDTableViewCellItem alloc] initWithTitle:@"还原设置" target:self action:@selector(_resetSettingActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item00]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"导航设置" target:self action:@selector(_navigationSettingActionFired)];
        STDTableViewSectionItem * section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item10]];
        [dataSource addObject:section1];
        
        STDTableViewCellItem *item20 = [[STDTableViewCellItem alloc] initWithTitle:@"允许自定义导航切换" target:self action:@selector(_navigationSettingActionFired:)];
        item20.switchStyle = YES;
        item20.checked = [[[STPersistence standardPerstence] valueForKey:@"STDAllowsCustomNavigationTransition"] boolValue];
        
        STDTableViewCellItem *item21 = [[STDTableViewCellItem alloc] initWithTitle:@"聊天接收图片" target:self action:@selector(_chatSettingActionFired:)];
        item21.switchStyle = YES;
        item21.checked = [[[STPersistence standardPerstence] valueForKey:@"STDChatAcceptImage"] boolValue];
        
        STDTableViewCellItem *item22 = [[STDTableViewCellItem alloc] initWithTitle:@"减少切换动画" target:self action:@selector(_reduceAnimationActionFired:)];
        item22.switchStyle = YES;
        item22.checked = [[[STPersistence standardPerstence] valueForKey:@"STDReduceTransitionAnimation"] boolValue];
        
        STDTableViewSectionItem * section2 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item20, item21, item22]];
        [dataSource addObject:section2];
        
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_navigationSettingActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPerstence] setValue:@(uiswitch.on) forKey:@"STDAllowsCustomNavigationTransition"];
    }
}

- (void)_reduceAnimationActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPerstence] setValue:@(uiswitch.on) forKey:@"STDReduceTransitionAnimation"];
        self.customTabBarController.animatedWhenTransition = !uiswitch.on;
    }
}

- (void)_chatSettingActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPerstence] setValue:@(uiswitch.on) forKey:@"STDChatAcceptImage"];
    }
}
- (void)_resetSettingActionFired {
    [STPersistence resetStandardPerstence];
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
    indicatorView.forceSquare = YES;
    indicatorView.indicatorType = STIndicatorTypeText;
    indicatorView.textLabel.text = @"还原完成";
    [indicatorView hideAnimated:YES afterDelay:0.5];
    indicatorView.blurEffectStyle = STBlurEffectStyleDark;
}

- (void)_navigationSettingActionFired {
    STDNavigationSettingViewController * settingViewController = [[STDNavigationSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:settingViewController animated:YES];
}

@end

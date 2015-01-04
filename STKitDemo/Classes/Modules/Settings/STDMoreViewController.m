//
//  STDMoreViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDMoreViewController.h"

#import <STKit/STKit.h>

#import "STDAboutViewController.h"
#import "STDRecordViewController.h"
#import "STDReaderViewController.h"
#import "STARootViewController.h"
#import "STDBlurSettingViewController.h"
#import "STDNavigationSettingViewController.h"
#import "STDAppDelegate.h"
#import "STDBigViewController.h"

@interface STDMoreViewController ()

@property (nonatomic, strong) NSArray    * dataSource;

@end

@implementation STDMoreViewController

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];
        
        STDTableViewCellItem * item00 = [[STDTableViewCellItem alloc] initWithTitle:@"清空缓存" target:self action:@selector(cleanActionFired)];
        STDTableViewCellItem * item01 = [[STDTableViewCellItem alloc] initWithTitle:@"还原设置" target:self action:@selector(resetSettingActionFired)];
        STDTableViewSectionItem * section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item00, item01]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem * item10 = [[STDTableViewCellItem alloc] initWithTitle:@"导航设置" target:self action:@selector(navigationSettingActionFired)];
        STDTableViewCellItem * item11 = [[STDTableViewCellItem alloc] initWithTitle:@"毛玻璃设置" target:self action:@selector(blurActionFired)];
        STDTableViewSectionItem * section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item10, item11]];
        [dataSource addObject:section1];
        
        STDTableViewCellItem * item20 = [[STDTableViewCellItem alloc] initWithTitle:@"豆瓣妹子" target:self action:@selector(dbMeiziActionFired)];
//        STDTableViewCellItem * item21 = [[STDTableViewCellItem alloc] initWithTitle:@"糗事百科" target:self action:@selector(qiubaiActionFired)];
        STDTableViewSectionItem * section2 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item20]];
        [dataSource addObject:section2];
        
        STDTableViewCellItem * item30 = [[STDTableViewCellItem alloc] initWithTitle:@"关于STKit" target:self action:@selector(aboutActionFired)];
        STDTableViewSectionItem * section3 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item30]];
        [dataSource addObject:section3];
        
        STDTableViewCellItem * item40 = [[STDTableViewCellItem alloc] initWithTitle:@"退出" target:self action:@selector(logoutActionFired)];
        STDTableViewSectionItem * section4 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item40]];
        [dataSource addObject:section4];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"更多介绍";
    
    [[STPersistence standardPerstence] setValue:@(YES) forKey:@"STHasEnteredAboutViewController"];
    
    if (self.customTabBarController) {
        [self.customTabBarController setBadgeValue:nil forIndex:2];
    }
    
    if (self.sideBarController) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0, 0, 60, 44);
        [button setImage:[UIImage imageNamed:@"nav_menu_normal.png"] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
        [button addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cleanActionFired {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * imagePath = STImageCacheDirectory();
    if ([manager fileExistsAtPath:imagePath isDirectory:NULL]) {
        CGFloat size = [[[manager attributesOfItemAtPath:imagePath error:nil] valueForKey:NSFileSize] floatValue];
        [manager removeItemAtPath:imagePath error:nil];
        STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
        indicatorView.forceSquare = YES;
        indicatorView.indicatorType = STIndicatorTypeText;
        indicatorView.textLabel.text = @"清理完毕";
        indicatorView.detailLabel.text = [NSString stringWithFormat:@"释放了%.2fM", size / 1024.f];
        [indicatorView hideAnimated:YES afterDelay:0.5];
        indicatorView.blurEffectStyle = STBlurEffectStyleDark;
    }
}

- (void) resetSettingActionFired {
    [STPersistence resetStandardPerstence];
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
    indicatorView.forceSquare = YES;
    indicatorView.indicatorType = STIndicatorTypeText;
    indicatorView.textLabel.text = @"还原完成";
    [indicatorView hideAnimated:YES afterDelay:0.5];
    indicatorView.blurEffectStyle = STBlurEffectStyleDark;
}

- (void) navigationSettingActionFired {
    STDNavigationSettingViewController * settingViewController = [[STDNavigationSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:settingViewController animated:YES];
}

- (void) blurActionFired {
    STDBlurSettingViewController * viewController = [[STDBlurSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void) dbMeiziActionFired {
    STDBigViewController * viewController = [[STDBigViewController alloc] init];
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void) qiubaiActionFired {
    NSString * qiubaiLibiary = [[NSBundle mainBundle] pathForResource:@"STQiuBai" ofType:@"framework"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
//    NSString * path = [[fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.suen.plugin"].path stringByAppendingPathComponent:@"/Library/STQiuBai.framework"];
    NSString * path = [STDocumentDirectory() stringByAppendingPathComponent:@"/STQiuBai.framework"];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager copyItemAtPath:qiubaiLibiary toPath:path error:nil];
    NSBundle * bundle = [[NSBundle alloc] initWithPath:qiubaiLibiary];
    NSError * error;
    if ([bundle loadAndReturnError:&error] && !error) {
        Class vc = NSClassFromString(@"STQBViewController");
        STViewController * viewController = [[vc alloc] initWithNibName:nil bundle:nil];
        [self.customNavigationController pushViewController:viewController animated:YES];
    }
}

- (void) aboutActionFired {
    STDAboutViewController * aboutViewController = [[STDAboutViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:aboutViewController animated:YES];
}

- (void) logoutActionFired {
    STDAppDelegate * appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate replaceRootViewController:[appDelegate startViewController] animationOptions:UIViewAnimationOptionTransitionFlipFromRight];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceDidRecognizerText:) name:@"STDVoiceRecognizerNotification" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STDVoiceRecognizerNotification" object:nil];
   
}

- (void) voiceDidRecognizerText:(NSNotification *) notification {
    NSString * text = [notification.userInfo valueForKey:@"text"];
    if ([text contains:@"退出"]) {
        STDAppDelegate * appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate replaceRootViewController:[appDelegate startViewController] animationOptions:UIViewAnimationOptionTransitionFlipFromRight];
    } else {
        [super voiceDidRecognizerText:notification];
    }
}

- (void) leftBarButtonItemAction:(id) sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}
@end

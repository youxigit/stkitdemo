//
//  STDNavigationTestViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationTestViewController.h"

@interface STDNavigationTestViewController ()

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation STDNavigationTestViewController

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.dataSource = @[@{@"title":@"从屏幕最左侧右滑拖动可以返回，支持iOS6。",@"section":@[@"Push一个有导航栏的", @"Push一个没有导航栏的", @"Push一个有TabBar的", @"Push一个没有TabBar的"]}, @{@"title":@"PopViewController", @"section":@[@"PopViewController", @"PopToRootViewController"]}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"测试导航";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:section];
    return [sectionInfo valueForKey:@"title"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:section];
    return [[sectionInfo valueForKey:@"section"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    // Configure the cell...
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:indexPath.section];
    NSString * text = [[sectionInfo valueForKey:@"section"] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = text;
    return tableViewCell;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return;
    }
    UILabel * textLabel = ((UITableViewHeaderFooterView * )view).textLabel;
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:section];
    NSString * title =  [sectionInfo valueForKey:@"title"];
    textLabel.text = title;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if (indexPath.row == 0) {
            viewController.navigationBarHidden = NO;
            viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
        } else if (indexPath.row == 1) {
            viewController.navigationBarHidden = YES;
            viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
        } else if (indexPath.row == 2) {
            viewController.navigationBarHidden = self.navigationBarHidden;
            viewController.hidesBottomBarWhenPushed = NO;
        } else {
            viewController.navigationBarHidden = self.navigationBarHidden;
            viewController.hidesBottomBarWhenPushed = YES;
        }
        [self.customNavigationController pushViewController:viewController animated:YES];
    } else {
        if (indexPath.row == 0) {
            [self.customNavigationController popViewControllerAnimated:YES];
        } else {
            [self.customNavigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end

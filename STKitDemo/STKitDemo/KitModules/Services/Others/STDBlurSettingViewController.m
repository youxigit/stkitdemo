//
//  STDBlurSettingViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-7-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDBlurSettingViewController.h"

@interface STDBlurSettingViewController ()

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation STDBlurSettingViewController

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSArray * dataSource = @[
                                 @{@"title" : @"None", @"value":@(STBlurEffectStyleNone)},
                                 @{@"title" : @"Light", @"value":@(STBlurEffectStyleLight)},
                                 @{@"title" : @"ExtraLight", @"value":@(STBlurEffectStyleExtraLight)},
                                 @{@"title" : @"Dark", @"value":@(STBlurEffectStyleDark)},
                                 ];
        self.hidesBottomBarWhenPushed = YES;
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"毛玻璃设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"目前，毛玻璃设置只针对指示器的设置";
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    NSString * title;
    title = [[self.dataSource objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.textLabel.text = title;
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STBlurEffectStyle style = [[[self.dataSource objectAtIndex:indexPath.row] valueForKey:@"value"] intValue];
    [self.tableView reloadData];
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
    indicatorView.blurEffectStyle = style;
    [indicatorView hideAnimated:YES afterDelay:1.0];
}


@end

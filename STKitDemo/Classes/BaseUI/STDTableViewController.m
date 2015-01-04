//
//  STDTableViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDTableViewController.h"

@interface STDTableViewController ()

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, assign) UITableViewStyle    tableViewStyle;

@end

@implementation STDTableViewController

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.tableViewStyle = tableViewStyle;
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithStyle:UITableViewStylePlain];
}

- (void) loadView {
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// config Cell
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void) voiceDidRecognizerText:(NSNotification *) notification {
    NSString * text = [notification.userInfo valueForKey:@"text"];
    if ([text contains:@"返回"]) {
        [super voiceDidRecognizerText:notification];
    }
    const NSArray * hanZi = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七",@"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十"];
    
    if (!([text contains:@"排"] || [text contains:@"行"] || [text contains:@"盘"])) {
        return;
    }
    __block int row = -1;
    [hanZi enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([text contains:[NSString stringWithFormat:@"第%@", obj]]) {
            row = idx;
            *stop = YES;
        }
    }];
    if (row == -1) {
        return;
    }
    NSUInteger section = 0;
    NSUInteger count = 0, index = 0;
    for (int i = 0; i < [self.tableView numberOfSections]; i ++) {
        for (int j = 0; j < [self.tableView numberOfRowsInSection:i]; j ++) {
            if (count == row) {
                section = i;
                index = j;
                goto result;
            }
            count ++;
        }
    }
result:
    if (section < [self.tableView numberOfSections] && index < [self.tableView numberOfRowsInSection:section]) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end

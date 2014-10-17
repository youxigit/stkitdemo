//
//  STDTableViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STKit.h>
#import "STDViewController.h"

@interface STDTableViewController : STDViewController  <UITableViewDataSource, UITableViewDelegate>

- (instancetype) initWithStyle:(UITableViewStyle) tableViewStyle;

@property (nonatomic, readonly, strong) UITableView       * tableView;

@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

@end

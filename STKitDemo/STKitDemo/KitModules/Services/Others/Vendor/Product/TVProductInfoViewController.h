//
//  TVProductInfoViewController.h
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTableViewController.h"
@class TVProductItem;
@interface TVProductInfoViewController : STDTableViewController

- (instancetype) initWithProductItem:(TVProductItem *) productItem;

@end

//
//  TVProductInfoViewController.m
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVProductInfoViewController.h"
#import "TVProductItem.h"

#import "AMProductCell.h"
#import "AMProductHeaderView.h"

#import <STKit/STKit.h>

@interface TVProductInfoViewController () <STImageViewControllerDelegate, AMProductCellDelegate>

@property (nonatomic, strong) TVProductItem * productItem;
@property (nonatomic, strong) AMProductHeaderView * productHeaderView;

@end

@implementation TVProductInfoViewController

- (instancetype) initWithProductItem:(TVProductItem *) productItem {
    self =[super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.productItem = productItem;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any setup after loading the view.
    self.navigationItem.title = @"私密新品";
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    
    AMProductHeaderView * productHeaderView = [[AMProductHeaderView alloc] initWithFrame:CGRectZero];
    self.productHeaderView = productHeaderView;
    
    [self.tableView registerClass:[AMProductCell class] forCellReuseIdentifier:[AMProductCell defaultProductCellIdentifier]];
    [self updateProductHeaderViewAnimated:NO];
}

- (void) updateProductHeaderViewAnimated:(BOOL) animated {
    NSString * productText = self.productItem.title;
    void (^ animations)(void) = ^{
        if (productText.length == 0) {
            self.tableView.tableHeaderView = nil;
        } else {
            self.productHeaderView.productText = productText;
            self.tableView.tableHeaderView = self.productHeaderView;
        }
    };
    if (!animated) {
        animations();
    } else {
        [UIView animateWithDuration:0.25 animations:animations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.productItem.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMProductCell * tableViewCell = (AMProductCell *)[tableView dequeueReusableCellWithIdentifier:[AMProductCell defaultProductCellIdentifier]];
    TVImageItem * imageItem = [self.productItem.images objectAtIndex:indexPath.row];
    tableViewCell.imageItem = imageItem;
    tableViewCell.delegate = self;
    // Configure the cell...
    return tableViewCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TVImageItem * imageItem = [self.productItem.images objectAtIndex:indexPath.row];
    return [AMProductCell heightForCellWithImageItem:imageItem];
}

- (void) thumbImageViewDidTouchedWithImageItem:(TVImageItem *)imageItem {
    NSInteger index = [self.productItem.images indexOfObject:imageItem];
    
    STImageViewController * imageViewController = [[STImageViewController alloc] init];
    NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:4];
    [self.productItem.images enumerateObjectsUsingBlock:^(TVImageItem * imageItem, NSUInteger idx, BOOL *stop) {
        [dataSource addObject:imageItem.toDictionary];
    }];
    imageViewController.imageDataSource = dataSource;
    imageViewController.delegate = self;
    imageViewController.navigationBarHidden = YES;
    [self.customNavigationController pushViewController:imageViewController animated:YES];
    imageViewController.selectedIndex = index;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

}

- (void) imageViewController:(STImageViewController *) imageViewController
     didScrollToImageAtIndex:(NSInteger) imageIndex {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:imageIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
@end

//
//  TVProductViewController.m
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVProductViewController.h"

#import "TVProductCell.h"
#import "TVProductItem.h"
#import "TVPublishToolbar.h"
#import "TVPublishViewController.h"
#import "TVRest.h"
#import "STMenuView.h"

#import "TVProductInfoViewController.h"

@interface TVProductViewController () <TVProductCellDelegate>

@property (nonatomic, strong) NSMutableArray * dataSource;


@property (nonatomic, assign) BOOL      hasMore;

@end

@implementation TVProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];
        self.dataSource = dataSource;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"新品列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" target:self action:@selector(moreActionFired:)];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    
    [self.tableView registerClass:[TVProductCell class] forCellReuseIdentifier:[TVProductCell defaultProductCellIdentifier]];
    CGRect frame = self.tableView.frame;
    frame.size.height -= 62;
    self.tableView.frame = frame;
    
    TVPublishToolbar * productToolbar = [[TVPublishToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 62, CGRectGetWidth(self.view.bounds), 62)];
    productToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [productToolbar.actionButton addTarget:self action:@selector(publishButtonActionFired:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:productToolbar];
    
    
    [self refreshData];
    
}

- (void) moreActionFired:(id) sender {
    STMenuItem * menuItem0 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole0"] highlightedImage:nil title:@"测试0"];
    STMenuItem * menuItem1 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole1"] highlightedImage:nil title:@"测试1"];
    STMenuItem * menuItem2 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole2"] highlightedImage:nil title:@"测试2"];
    STMenuItem * menuItem3 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole3"] highlightedImage:nil title:@"测试3"];
    STMenuItem * menuItem4 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole4"] highlightedImage:nil title:@"测试4"];
    STMenuItem * menuItem5 = [[STMenuItem alloc] initWithImage:[UIImage imageNamed:@"wormhole5"] highlightedImage:nil title:@"测试5"];
    STMenuView * menuView = [[STMenuView alloc] initWithDelegate:self menuItem:menuItem0, menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, nil];
    [menuView showInView:self.customNavigationController.view animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) pullRefreshData {
    __weak TVProductViewController * weakSelf = self;
    [[TVRest defaultRest] fetchProductionWithPageSize:20 pageNumber:0 handler:^(STNetworkOperation * operation, id result, NSError * error) {
        if (error) {
            return;
        }
        [weakSelf.dataSource removeAllObjects];
        weakSelf.hasMore = [[result valueForKey:@"hasMore"] boolValue];
        NSArray * products = [result valueForKey:@"products"];
        if ([products isKindOfClass:[NSArray class]]) {
            [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [weakSelf.dataSource addObject:[[TVProductItem alloc] initWithDictionary:obj]];
            }];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void) refreshData {

    [STIndicatorView showInView:self.view animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        UIGestureRecognizer * gesture = [self.navigationController performSelector:@selector(interactivePopGestureRecognizer)];
        gesture.enabled = NO;
    }
    __weak TVProductViewController * weakSelf = self;
    [[TVRest defaultRest] fetchProductionWithPageSize:20 pageNumber:0 handler:^(STNetworkOperation * response, id result, NSError * error) {
        [STIndicatorView hideInView:weakSelf.view animated:YES];
        if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            UIGestureRecognizer * gesture = [self.navigationController performSelector:@selector(interactivePopGestureRecognizer)];
            gesture.enabled = YES;
        }
        if (error) {
            return;
        }
        [weakSelf.dataSource removeAllObjects];
        weakSelf.hasMore = [[result valueForKey:@"hasMore"] boolValue];
        NSArray * products = [result valueForKey:@"products"];
        if ([products isKindOfClass:[NSArray class]]) {
            [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [weakSelf.dataSource addObject:[[TVProductItem alloc] initWithDictionary:obj]];
            }];
            [weakSelf.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// config Cell
    TVProductItem * productItem = [self.dataSource objectAtIndex:indexPath.row];
    TVProductCell * productCell = [tableView dequeueReusableCellWithIdentifier:[TVProductCell defaultProductCellIdentifier]];
    productCell.delegate = self;
    productCell.productItem = productItem;
    return productCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TVProductCell defaultProductCellHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TVProductItem * productItem = [self.dataSource objectAtIndex:indexPath.row];
    TVProductInfoViewController * viewController = [[TVProductInfoViewController alloc] initWithProductItem:productItem];
    [self.customNavigationController pushViewController:viewController animated:YES];
}

#pragma mark - PublishButtonAction
- (void) publishButtonActionFired:(id) sender {
    TVPublishViewController * publishVC = TVPublishViewController.new;
    [self.customNavigationController pushViewController:publishVC animated:YES];
}

#pragma mark - UINavigationItemAction
- (void) leftBarButtonItemAction:(id) sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}

- (void) rightBarButtonItemAction:(id) sender {

}

- (void) didFiredImageAction:(UIImageView *) imageView imageItem:(TVImageItem *) imageItem {
    [STImagePresent presentImageView:imageView hdImageURL:imageItem.imageURL];
}

@end

//
//  STDNavigationTestViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationTestViewController.h"

@interface STDNavigationTestViewController () <STNavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

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
    if (![self.customNavigationController.delegate isKindOfClass:[self class]]) {
         self.customNavigationController.delegate = self;   
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}



- (void)navigationController:(STNavigationController *)navigationController willBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *targetView;
    CGFloat originAngle;
    if (transitionContext.transitionType == STViewControllerTransitionTypePop) {
        targetView = transitionContext.fromView;
        originAngle = 0;
    } else {
        targetView = transitionContext.toView;
        originAngle = M_PI_2;
    }
    targetView.anchorPoint = CGPointMake(0.0, 1.0);
    targetView.layer.transform = CATransform3DMakeRotation(originAngle, 0.0, .0, 1.0);
}

#define finalAngel 30.0f
#define perspective 1.0/-600
#define finalAlpha 0.6f

- (void)navigationController:(STNavigationController *)navigationController transitingWithContext:(STNavigationControllerTransitionContext *)transitionContext {
    CGFloat completion = transitionContext.completion;
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView;
    STViewControllerTransitionType transitionType = transitionContext.transitionType;
    UIView *targetView;
    if (transitionType == STViewControllerTransitionTypePop) {
        targetView = fromView;
    } else {
        targetView = toView;
        completion = (1.0 - completion);
    }
    targetView.layer.transform = CATransform3DMakeRotation(M_PI_2 * completion, 0.0, .0, 1.0);
    return;

    UIView *transitionView = transitionContext.transitionView;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    
    CGFloat angle =  finalAngel * M_PI / 180.0f * completion;
    if(transitionType == STViewControllerTransitionTypePop){
        angle = -angle;
    }
    transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    fromView.layer.transform = transform;
    fromView.alpha =  1 - completion*(1-finalAlpha);
    
    if(targetView){
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = perspective;
        CGFloat angle =  - finalAngel * M_PI / 180.0f * (1-completion);
        if(transitionContext.transitionType == STViewControllerTransitionTypePop){
            angle = -angle;
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
        targetView.layer.transform = transform;
        targetView.alpha = finalAlpha + (1-finalAlpha)*completion;
    }
    
    UIViewController *fromViewController = transitionContext.fromViewController, *targetViewController = transitionContext.toViewController;
    CGRect fromViewFrame = fromView.frame, toViewFrame = targetView.frame;
    if (transitionType == STViewControllerTransitionTypePop) {
        CGFloat panOffset = MAX(MIN(fromViewController.interactivePopTransitionOffset, CGRectGetWidth(transitionView.bounds)), 0);
        fromViewFrame.origin.x = completion * (CGRectGetWidth(transitionView.frame) + 80);
        toViewFrame.origin.x = -panOffset + completion * panOffset - (1-completion)*80;
    } else {
        CGFloat panOffset = MAX(MIN(targetViewController.interactivePopTransitionOffset, CGRectGetWidth(transitionView.bounds)), 0);
        fromViewFrame.origin.x = -panOffset + (1.0 - completion) *panOffset - completion * 100;
        toViewFrame.origin.x = (1.0-completion) *CGRectGetWidth(transitionContext.transitionView.bounds) + (1-completion)*100;
    }
    fromView.frame = fromViewFrame;
    targetView.frame = toViewFrame;
}

- (void)navigationController:(STNavigationController *)navigationController didEndTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView;
    fromView.anchorPoint = CGPointMake(0.5, 0.5);
    fromView.layer.transform = CATransform3DIdentity;
    toView.anchorPoint = CGPointMake(0.5, 0.5);
    toView.layer.transform = CATransform3DIdentity;
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

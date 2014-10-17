//
//  STDCollectionViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDCollectionViewController.h"
#import "STDCollectionViewFlowLayout.h"
#import "STPhotoCollectionViewCell.h"

#import <STKit/STKit.h>

@interface STDCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) STDCollectionViewFlowLayout * collectionViewLayout;
@property (nonatomic, assign) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * layoutAttributes;
@property (nonatomic, assign) NSInteger        zoomLavel;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CFAbsoluteTime absoluteTime;

@property (nonatomic, assign) UIView    * operationView;

- (void) zoomInCollectionView:(id) sender;
- (void) zoomOutCollectionView:(id) sender;

@property (nonatomic, assign) BOOL refreshing;

@end

@implementation STDCollectionViewController

- (void) dealloc {
    
    
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray * layoutAttributes = [NSMutableArray arrayWithCapacity:10];
        NSDictionary * attribute1 = @{@"preferredSize":NSStringFromCGSize(CGSizeMake(48, 60)), @"preferredHorizontalSpacing" : @(7.), @"preferredVerticalSpacing" : @(7.)};
        [layoutAttributes addObject:attribute1];
        NSDictionary * attribute2 = @{@"preferredSize":NSStringFromCGSize(CGSizeMake(64, 80)), @"preferredHorizontalSpacing" : @(9.), @"preferredVerticalSpacing" : @(9.)};
        [layoutAttributes addObject:attribute2];
        NSDictionary * attribute4 = @{@"preferredSize":NSStringFromCGSize(CGSizeMake(96, 120)), @"preferredHorizontalSpacing" : @(13.), @"preferredVerticalSpacing" : @(13)};
        [layoutAttributes addObject:attribute4];
        NSDictionary * attribute5 = @{@"preferredSize":NSStringFromCGSize(CGSizeMake(144, 180)), @"preferredHorizontalSpacing" : @(15.), @"preferredVerticalSpacing" : @(15.)};
        [layoutAttributes addObject:attribute5];
        NSDictionary * attribute6 = @{@"preferredSize":NSStringFromCGSize(CGSizeMake(300, 320)), @"preferredHorizontalSpacing" : @(17.), @"preferredVerticalSpacing" : @(17.)};
        [layoutAttributes addObject:attribute6];
        self.layoutAttributes = layoutAttributes;
        
        STDCollectionViewFlowLayout * collectionViewFlowLayout = [[STDCollectionViewFlowLayout alloc] init];
        self.collectionViewLayout = collectionViewFlowLayout;
        self.zoomLavel = 2;
        
        self.dataSource = [NSMutableArray arrayWithCapacity:5];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"图片来自缓存";
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 30) collectionViewLayout:self.collectionViewLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.clipsToBounds = NO;
    [collectionView registerClass:[STPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Identifier"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.clipsToBounds = YES;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIView * operationView = UIView.new;
    operationView.translatesAutoresizingMaskIntoConstraints = NO;
    operationView.backgroundColor = [UIColor darkGrayColor];
    operationView.alpha = 0.7;
    operationView.layer.cornerRadius = 5.0;
    operationView.layer.masksToBounds = YES;
    [self.view addSubview:operationView];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(operationView, collectionView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView(>=100)]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[collectionView(>=100)]-30-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=100)-[operationView(100)]-5-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=100)-[operationView(40)]-(30)-|" options:0 metrics:nil views:views]];
    
    UIButton * zoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zoomIn addTarget:self action:@selector(zoomInCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    zoomIn.translatesAutoresizingMaskIntoConstraints = NO;
    zoomIn.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 8);
    [zoomIn setImage:[UIImage imageNamed:@"viewer_zoom_in.png"] forState:UIControlStateNormal];
    [operationView addSubview:zoomIn];
    
    UIButton * zoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [zoomOut addTarget:self action:@selector(zoomOutCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    zoomOut.translatesAutoresizingMaskIntoConstraints = NO;
    zoomOut.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 4);
    [zoomOut setImage:[UIImage imageNamed:@"viewer_zoom_out.png"] forState:UIControlStateNormal];
    [operationView addSubview:zoomOut];
    
    NSDictionary * buttons = NSDictionaryOfVariableBindings(zoomIn, zoomOut);
    [operationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[zoomIn(>=20)]-10-[zoomOut(==zoomIn)]-2-|" options:0 metrics:nil views:buttons]];
    [operationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[zoomIn(>=20)]-2-|" options:0 metrics:nil views:buttons]];
    [operationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[zoomOut(>=20)]-2-|" options:0 metrics:nil views:buttons]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataSource.count == 0 && !self.refreshing) {
        [self refresh];
    }
}

- (void) refresh {
    self.refreshing = YES;
    [STIndicatorView showInView:self.view animated:NO];
    STRESTNetwork * network = [[STRESTNetwork alloc] initWithHost:@"http://www.lovecard.sinaapp.com" path:@"open"];
    NSDictionary * parameters = @{@"page":@(1), @"size":@(200)};
    [network sendAsynchronousRequestWithMethod:@"photo/list" parameters:parameters handler:^(NSURLResponse * response, id result, NSError *error) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[result objectForKey:@"photos"]];
        [self.collectionView reloadData];
        [STIndicatorView hideInView:self.view animated:YES];
        self.refreshing = NO;
    }];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count * 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        static NSString * identifier = @"Identifier";
        STPhotoCollectionViewCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSDictionary * photoDictionary = [self.dataSource objectAtIndex:indexPath.row % self.dataSource.count];
        [collectionViewCell setPhotoDictionary:photoDictionary];
        return collectionViewCell;
    }
    
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *) scrollView {
    self.absoluteTime = CACurrentMediaTime();
    self.offsetX = CGRectGetMidX(scrollView.visibleRect);
    
    self.customNavigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.customNavigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.layer.transform = CATransform3DIdentity;
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    
    CGFloat distance = CGRectGetMidX(scrollView.visibleRect) - self.offsetX;
    CGFloat time     = CACurrentMediaTime() - self.absoluteTime;
    time = MAX(time, 0.01);
    CGFloat speed    = ABS(distance / time);
    CGFloat zoom;
    if (speed >= 3000) {
        zoom = M_PI_4 * 0.4;
    } else if (speed >= 2000) {
        zoom = M_PI_4 * 0.3;
    } else if (speed >= 1000){
        zoom = M_PI_4 * 0.2;
    } else if (speed >= 500){
        zoom = M_PI_4 * 0.1;
    } else {
        zoom = 0;
    }
    if (scrollView.contentOffset.x < 0 || (scrollView.contentOffset.x + scrollView.bounds.size.width) > scrollView.contentSize.width) {
        zoom = 0;
    }
    if (distance < 0) {
        zoom *= -1;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1 / 850.f;
    transform = CATransform3DRotate(transform, zoom , 0., 1., 0.);
    scrollView.layer.transform = transform;
    
    self.absoluteTime = CACurrentMediaTime();
    self.offsetX = CGRectGetMidX(scrollView.visibleRect);
}

#pragma mark - Zoom Method

- (void) zoomInCollectionView:(id) sender {
    NSInteger level = self.zoomLavel;
    level --;
    if (level < 0) {
        level = 0;
    }
    self.zoomLavel = level;
}

- (void) zoomOutCollectionView:(id) sender {
    NSInteger level = self.zoomLavel;
    level ++;
    if (level >= self.layoutAttributes.count) {
        level = self.layoutAttributes.count -1;
    }
    self.zoomLavel = level;
}

#pragma mark - Private Method



- (void) setZoomLavel:(NSInteger) zoomLavel {
    if (zoomLavel <0 || zoomLavel >= self.layoutAttributes.count) {
        return;
    }
    //    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:self.collectionView.visibleRect.origin];
    NSDictionary * attributes = [self.layoutAttributes objectAtIndex:zoomLavel];
    self.collectionViewLayout.preferredLayoutAttributes = attributes;
    [self.collectionViewLayout relayout];
    _zoomLavel = zoomLavel;
}

- (void) updateCollectionViewLayoutWithAttributes:(NSDictionary *) attributes {
    
}
@end

@implementation UIScrollView (SVisibleRect)

- (CGRect) visibleRect {
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
    return visibleRect;
}

@end
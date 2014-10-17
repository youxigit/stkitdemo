//
//  TVPublishViewController.m
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVPublishViewController.h"

#import "TVPublishToolbar.h"
#import "TVPublishImageCell.h"
#import "TVImageChooseCell.h"

#import "TVRest.h"

#import "ZipArchive.h"

#import <STKit/STKit.h>
#import <STKit/STImageCache.h>

@interface TVPublishViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, STImagePickerControllerDelegate, TVImageChooseDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray   * dataSource;

@property (nonatomic, strong) STTextView       * textView;

@end

@implementation TVPublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.maximumNumberOfImage = 9;
        self.dataSource = [NSMutableArray arrayWithCapacity:9];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"新品发布";
    
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    rightBtn.frame = CGRectMake(0, 0, 62, 44);
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"nav_done_normal.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.textView = [[STTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 80)];
    self.textView.placeholder = @"描述一下你的产品";
    self.textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.textView];

    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.itemSize = CGSizeMake(64, 64);
    CGRect collectionFrame = CGRectMake(10, 100, 300, 84);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:flowLayout];
    self.collectionView.layer.cornerRadius = 10.;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.backgroundView = nil;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView.backgroundColor = [UIColor colorWithRGB:0xf0f1f2];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TVImageChooseCell class] forCellWithReuseIdentifier:@"ChooseIdentifier"];
    [self.collectionView registerClass:[TVPublishImageCell class] forCellWithReuseIdentifier:@"Identifier"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) publishButtonActionFired:(id) sender {
    
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (void) collectionSizeToFit {

    CGFloat height = self.collectionView.contentSize.height + 20;
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.size.height = height;
    self.collectionView.frame = collectionFrame;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.dataSource.count < self.maximumNumberOfImage) {
        count = self.dataSource.count + 1;
    } else {
        count = self.dataSource.count;
    }
    return count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /// 是否有 + 选择的 按钮
    BOOL hasChooseCell = (self.dataSource.count < self.maximumNumberOfImage);
    if (indexPath.row == self.dataSource.count && hasChooseCell) {
        TVImageChooseCell * collectionViewCell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseIdentifier" forIndexPath:indexPath];
        collectionViewCell.delegate = self;
        return collectionViewCell;
    }
    NSDictionary * imageInfo = [self.dataSource objectAtIndex:indexPath.row];
    UIImage * thumbImage = [imageInfo valueForKey:STImagePickerControllerThumbImage];
    TVPublishImageCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Identifier" forIndexPath:indexPath];
    collectionViewCell.imageView.image = thumbImage;
    return collectionViewCell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        TVPublishImageCell * collectionCell = (TVPublishImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([collectionCell isKindOfClass:[TVPublishImageCell class]]) {
            NSDictionary * imageInfo = [self.dataSource objectAtIndex:indexPath.row];
            NSString * imagePath = [imageInfo valueForKey:STImagePickerControllerOriginalImagePath];
            [STImagePresent presentImageView:collectionCell.imageView hdImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
}

#pragma mark - STImagePickerDelegate
- (void)imagePickerController:(STImagePickerController *)picker didFinishPickingImageWithInfo:(NSDictionary *)info {
    NSArray * assets = [info valueForKey:@"data"];
    NSInteger previousCount = self.dataSource.count;
    NSInteger previousItemCount = [self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:assets.count];
    __block NSInteger startIndex = previousCount;
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.dataSource addObject:obj];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:startIndex inSection:0];
        startIndex ++;
        [indexPaths addObject:indexPath];
    }];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        if (previousCount < previousItemCount && self.dataSource.count >= self.maximumNumberOfImage) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:previousItemCount - 1 inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        
    } completion:^(BOOL finished) {
        [self collectionSizeToFit];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(STImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imageChooseActionFiredWithSender:(UIButton *) chooseButton {
    STImagePickerController * imagePicker = STImagePickerController.new;
    imagePicker.delegate = self;
    imagePicker.maximumNumberOfSelection = self.maximumNumberOfImage - self.dataSource.count;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
    if ([self.textView.text stringByTrimingWhitespace].length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请输入商品描述" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (self.dataSource.count == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"您没有选择图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [self.textView resignFirstResponder];
    self.customNavigationController.interactivePopGestureRecognizer.enabled = NO;
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        indicatorView.textLabel.text = @"正在压缩...";
        NSArray * assets = self.dataSource;
        ZipArchive * archive = [[ZipArchive alloc] init];
        NSString * path = STTemporaryDirectory();
        NSString * tempZip = [path stringByAppendingString:@"/temp.zip"];
        [archive CreateZipFile2:tempZip];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        __block NSInteger index = 0;
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString * imagePath = [obj valueForKey:STImagePickerControllerOriginalImagePath];
            [archive addFileToZip:imagePath newname:[NSString stringWithFormat:@"%lf_%d.jpg", timeInterval, index]];
            index ++;
        }];
        [archive CloseZipFile2];
        dispatch_sync(dispatch_get_main_queue(), ^{
           indicatorView.textLabel.text = @"正在上传...";
        });
        NSString * title = [self.textView.text stringByTrimingWhitespace];
        [[TVRest defaultRest] uploadFileToDefaultPath:tempZip handler:^(id response, id result, NSError * error) {
            if (error || ![result valueForKey:@"images"]) {
                return;
            }
            NSArray * images = [result valueForKey:@"images"];
            NSArray * imageIds = [images valueForKey:@"imageId"];
            NSString * imageIdString = [NSString stringWithFormat:@"[%@]", [imageIds componentsJoinedByString:@","]];
            [[TVRest defaultRest] publishProductWithName:nil title:title imageIds:imageIdString handler:^(id response1, id result1, NSError * error1) {
                indicatorView.textLabel.text = @"发布成功";
                [indicatorView hideAnimated:YES afterDelay:0.35];
                
                self.customNavigationController.interactivePopGestureRecognizer.enabled = YES;
                [self.customNavigationController popViewControllerAnimated:YES];
            }];
        }];
    });
    
}

@end

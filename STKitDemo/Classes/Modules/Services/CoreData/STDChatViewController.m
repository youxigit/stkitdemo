//
//  STDChatViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-18.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDChatViewController.h"

#import <STKit/STKit.h>
#import <STKit/STAlbumManager.h>

#import "STDChat.h"
#import "STDBaseChatCell.h"
#import "STDTextChatCell.h"
#import "STDImageChatCell.h"

#import "STDImage.h"
#import "STDMessage.h"
#import "STDEntityDefines.h"
#import "STDUser.h"
#import "STDChatInputView.h"

@interface STDChatViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@property (nonatomic, strong) NSArray * textContent;
@property (nonatomic, strong) NSArray * imageContent;

@property (nonatomic, strong) STDChatInputView * chatInputView;
@property (nonatomic, assign) BOOL      needScrollBottom;

@property (nonatomic, assign) BOOL      tableViewEditing;

@property (nonatomic, strong) NSMutableArray   * selectedManagedObjects;
@end

static NSString * STUserDefaultID = @"97676901";
static NSString * STSystemDefaultID = @"97676900";

@implementation STDChatViewController

#pragma mark - UserInteraction
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self initWithPageInfo:nil];
}

- (id) initWithPageInfo:(NSDictionary *) pageInfo {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"STDMessage"];
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil cacheName:nil];
        [self.fetchedResultsController performFetch:nil];
        self.fetchedResultsController.delegate = self;
        
        self.textContent = @[@"曲曲折折的荷塘上面，弥望的是田田的叶子。叶子出水很高，像亭亭的舞女的裙。层层的叶子中间，零星地点缀着些白花，有袅娜地开着的，有羞涩地打着朵儿的；正如一粒粒的明珠，又如碧天里的星星，又如刚出浴的美人。微风过处，送来缕缕清香，仿佛远处高楼上渺茫的歌声似的。这时候叶子与花也有一丝的颤动，像闪电般，霎时传过荷塘的那边去了。叶子本是肩并肩密密地挨着，这便宛然有了一道凝碧的波痕。叶子底下是脉脉的流水，遮住了，不能见一些颜色；而叶子却更见风致了。", @"道生一，一生二，二生三，三生万物。万物负阴而抱阳，冲气以为和。人之所恶，唯孤、寡、不谷，而王公以为称。故物或损之而益，或益之而损。人之所教，我亦教之。强梁者不得其死，吾将以为教父。", @"先帝创业未半而中道崩殂，今天下三分，益州疲弊，此诚危急存亡之秋也。然侍卫之臣不懈于内，忠志之士忘身于外者，盖追先帝之殊遇，欲报之于陛下也。诚宜开张圣听，以光先帝遗德，恢弘志士之气，不宜妄自菲薄，引喻失义，以塞忠谏之路也。", @"先天下之忧而忧，后天下之乐而乐。", @"永和九年， 岁在癸丑， 暮春之初， 会于会稽山阴之兰亭， 修禊事也。 群贤毕至， 少长咸集。 此地有崇山峻岭， 茂林修竹； 又有清流激湍， 映带左右， 引以为流觞曲水， 列坐其次。 虽无丝竹管弦之盛， 一觞一咏， 亦足以畅叙幽情。", @"只因为在人群中多看了你一眼，再也没能忘掉你的容颜，梦想着偶然能有一天再相见，从此我开始孤单地思念。想你时你在天边，想你时你在眼前，想你时你在脑海，想你时你在心田。宁愿相信我们前世有约，今生的爱情故事不会再改变。宁愿用这一生等你发现，我一直在你身边，从未走远。"];
        
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
        NSArray * size = @[@"440*586", @"600*923", @"580*796", @"1004*1500", @"312*400", @"640*960", @"733*734", @"1280*1024"];
        for (int i = 1; i <= 8; i ++) {
            NSString * imageName = [NSString stringWithFormat:@"chat_image_%d.jpg", i];
            NSDictionary * dictionary = @{@"imageURL":imageName, @"size":size[i - 1]};
            [array addObject:dictionary];
        }
        self.imageContent = array;
        
        self.selectedManagedObjects = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (STDUser *) createUserIfNotExistWithID:(NSString *) userId inManageObjectContext:(NSManagedObjectContext *) managedObjectContext {
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"STDUser"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uid=%@", userId];
    NSArray * users = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (users.count >= 1) {
        return [users objectAtIndex:0];
    }
    STDUser * user = (STDUser *)[managedObjectContext entityClassFromString:@"STDUser" name:@"STDUser"];
    user.uid = userId;
    return user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"聊天模板";
    
    UIButton * rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView setTitle:@"截屏" forState:UIControlStateNormal];
    [rightView setTitleColor:[UIColor colorWithRGB:0xFF7300] forState:UIControlStateNormal];
    [rightView addTarget:self action:@selector(shotMessageView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.customNavigationController.sideInteractionArea = STSideInteractiveAreaNavigationBar;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRGB:0xE2E4E5];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerClass:[STDTextChatCell class] forCellReuseIdentifier:NXChatCellTextLeftIdentifier];
    [self.tableView registerClass:[STDTextChatCell class] forCellReuseIdentifier:NXChatCellTextRightIdentifier];
    [self.tableView registerClass:[STDImageChatCell class] forCellReuseIdentifier:NXChatCellImageLeftIdentifier];
    [self.tableView registerClass:[STDImageChatCell class] forCellReuseIdentifier:NXChatCellImageRightIdentifier];
    
    STDChatInputView * chatInputView = [[STDChatInputView alloc] initWithSuperView:self.view];
    [chatInputView.sendButton addTarget:self action:@selector(saveMessageInBackground:) forControlEvents:UIControlEventTouchUpInside];
    [chatInputView sizeToFit];
    [self.view addSubview:chatInputView];
    self.chatInputView = chatInputView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInputViewDidChanged:) name:STDChatInputViewDidChangeNotification object:chatInputView];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTapRecognizerFired:)];
    tapGestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height - CGRectGetHeight(chatInputView.bounds));
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self.chatInputView resignFirstResponder];
    return NO;
}

- (void) collectionViewTapRecognizerFired:(id) sender {
    
}

#pragma mark - Notification

- (void) chatInputViewDidChanged:(NSNotification *) notification {
    NSTimeInterval duration = [[notification.userInfo valueForKey:STDChatInputViewAnimationDurationUserInfoKey] doubleValue];
    CGRect chatViewFrame = [[notification.userInfo valueForKey:STDChatInputViewFrameUserInfoKey] CGRectValue];
    CGFloat chatOriginY = CGRectGetMinY(chatViewFrame);
    CGRect frame = self.tableView.frame;
    CGFloat collectionViewVisibleHeight = CGRectGetHeight(self.view.frame) - chatOriginY;
    if (collectionViewVisibleHeight < self.tableView.contentSize.height) {
        frame.origin.y = chatOriginY - frame.size.height;
    } else {
        frame.origin.y = 0;
    }
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame = frame;
    }];
}

- (void) saveMessageInBackground:(id) sender {
    NSString * text = [self.chatInputView.text stringByTrimingWhitespace];
    self.chatInputView.text = nil;
    if (text.length == 0) {
        return;
    }
    [[STCoreDataManager defaultDataManager] performBlockInBackground:^(NSManagedObjectContext * managedObjectContext) {
        STDUser * user = [self createUserIfNotExistWithID:STUserDefaultID inManageObjectContext:managedObjectContext];
        STDMessage * message = (STDMessage *)[managedObjectContext entityClassFromString:@"STDMessage" name:@"STDMessage"];
        message.from = user;
        message.type = STDMessageTypeText;
        message.content = text;
        message.time = [[NSDate date] timeIntervalSince1970];
        NSString * identifier;
        CGRect chatViewRect;
        CGFloat height = [STDChat heightForMessageWithEntity:message identifier:&identifier chatViewRect:&chatViewRect];
        message.height = height;
        message.identifier = identifier;
        message.chatViewRect = NSStringFromCGRect(chatViewRect);
        [managedObjectContext save:nil];
    } waitUntilDone:NO];
    
    [[STCoreDataManager defaultDataManager] performBlockInBackground:^(NSManagedObjectContext * managedObjectContext) {
        STDUser * user = [self createUserIfNotExistWithID:STSystemDefaultID inManageObjectContext:managedObjectContext];
        STDMessage * message = (STDMessage *)[managedObjectContext entityClassFromString:@"STDMessage" name:@"STDMessage"];
        message.target = user;
        int type = arc4random() % 2;
        if (type) {
            message.type = STDMessageTypeText;
            int contentIdx = (arc4random() % self.textContent.count);
            message.content = [self.textContent objectAtIndex:contentIdx];
        } else {
            message.type = STDMessageTypeImage;
            int contentIdx = (arc4random() % self.imageContent.count);
            NSDictionary * info = [self.imageContent objectAtIndex:contentIdx];
            NSString * size = [info valueForKey:@"size"];
            NSArray * sizes = [size componentsSeparatedByString:@"*"];
            STDImage * image = (STDImage *)[managedObjectContext entityClassFromString:@"STDImage" name:@"STDImage"];
            image.width = [sizes[0] floatValue];
            image.height = [sizes[1] floatValue];
            image.imageURL = [info valueForKey:@"imageURL"];
            message.image = image;
        }
        message.time = [[NSDate date] timeIntervalSince1970];
        NSString * identifier;
        CGRect chatViewRect;
        CGFloat height = [STDChat heightForMessageWithEntity:message identifier:&identifier chatViewRect:&chatViewRect];
        message.height = height;
        message.identifier = identifier;
        message.chatViewRect = NSStringFromCGRect(chatViewRect);
        [[STCoreDataManager defaultDataManager] saveManagedObjectContext:managedObjectContext error:nil];
    } waitUntilDone:NO];
}


#pragma mark - TableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    STDMessage * message = (STDMessage *) managedObject;
    return message.height + 5;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STDMessage * message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    STDBaseChatCell * chatViewCell = [tableView dequeueReusableCellWithIdentifier:message.identifier forIndexPath:indexPath];
    chatViewCell.message = message;
    return chatViewCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STDMessage * message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.selectedManagedObjects addObject:message];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    STDMessage * message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.selectedManagedObjects removeObject:message];
}

#pragma mark - NSFetchedResultsDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            self.needScrollBottom = YES;
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
    if (self.needScrollBottom) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToBottomAnimated:YES];
        });
    }
    self.needScrollBottom = NO;
}

- (void) shotMessageView:(id) sender {
    
    UIButton * rightBarButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    if ([self.tableView numberOfRowsInSection:0] == 0) {
        if (self.tableView.isEditing) {
            [self.tableView setEditing:NO animated:NO];
        }
        [self.selectedManagedObjects removeAllObjects];
        self.tableViewEditing = NO;
        [rightBarButton setTitle:@"截屏" forState:UIControlStateNormal];
        return;
    }
    if (!self.tableViewEditing) {
        [self.selectedManagedObjects removeAllObjects];
        [self.tableView setEditing:YES animated:YES];
        self.tableViewEditing = YES;
        [rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
        return;
    }
    [self.tableView setEditing:NO animated:NO];
    self.tableViewEditing = NO;
    if (self.selectedManagedObjects.count == 0) {
        [rightBarButton setTitle:@"截屏" forState:UIControlStateNormal];
        return;
    }
    [STIndicatorView showInView:self.view animated:NO];
    
    
    UIView * shotView = [[UIView alloc] initWithFrame:CGRectZero];
    shotView.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:shotView];
    
    NSArray * messages = [self.selectedManagedObjects sortedArrayUsingComparator:^NSComparisonResult(STDMessage * obj1, STDMessage * obj2) {
        return obj1.time < obj2.time ? NSOrderedAscending:NSOrderedDescending;
    }];
    __block NSInteger top = 0;
    CGFloat width = CGRectGetWidth(self.tableView.frame);
    [messages enumerateObjectsUsingBlock:^(STDMessage * message, NSUInteger idx, BOOL *stop) {
        UIView * messageCell;
        switch (message.type) {
            case STDMessageTypeText:
                messageCell = [[STDTextChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:message.identifier];
                break;
            case STDMessageTypeImage:
                messageCell = [[STDImageChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:message.identifier];
                break;
            default:
                break;
        }
        messageCell.frame = CGRectMake(0, top, width, message.height + 5);
        [messageCell setValue:message forKey:@"message"];
        top += message.height + 5;
        [shotView addSubview:messageCell];
    }];
    CGRect shotFrame = shotView.frame;
    shotFrame.size.height = top;
    shotFrame.size.width = CGRectGetWidth(self.tableView.frame);
    shotView.frame = shotFrame;
    
    UIGraphicsBeginImageContextWithOptions(shotView.frame.size, false, [UIScreen mainScreen].scale);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [shotView.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存到相册中
    __weak STDChatViewController *weakSelf = self;
    STImageWriteToPhotosAlbum(image, @"STKitDemo",
                              ^(UIImage *image, NSError *error) { [weakSelf image:image didFinishSavingWithError:error contextInfo:NULL]; });
    [shotView removeFromSuperview];
    [STIndicatorView hideInView:self.view animated:YES];
    
    [rightBarButton setTitle:@"截屏" forState:UIControlStateNormal];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        STIndicatorView *indicatorView = [STIndicatorView showInView:self.view.window animated:YES];
        indicatorView.blurEffectStyle = STBlurEffectStyleDark;
        indicatorView.indicatorType = STIndicatorTypeText;
        indicatorView.textLabel.text = @"保存成功";
        indicatorView.cornerRadius = 2;
        indicatorView.textLabel.font = [UIFont systemFontOfSize:18];
        indicatorView.minimumSize = CGSizeMake(130, 80);
        indicatorView.forceSquare = NO;
        [indicatorView hideAnimated:YES afterDelay:1.5];
    }
}


- (void) leftBarButtonItemAction:(id) sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.tableView reloadData];
}

@end


@implementation UITableView (STScrollToBottom)

- (void) scrollToBottomAnimated:(BOOL)animated {
    NSInteger sections = self.numberOfSections;
    if (sections == 0) {
        return;
    }
    while (![self numberOfRowsInSection:(sections - 1)] && sections >= 1) {
        sections --;
    }
    if (sections == 0) {
        return;
    }
    NSInteger rows = [self numberOfRowsInSection:(sections - 1)];
    if (CGRectGetHeight(self.bounds) > self.contentSize.height) {
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:(rows - 1) inSection:(sections - 1)];
    void(^animations)(void) = ^(void) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    };
    if (animated) {
        [UIView animateWithDuration:0.15 animations:animations];
    } else {
        animations();
    }
}

@end
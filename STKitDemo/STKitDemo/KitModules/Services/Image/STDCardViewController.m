//
//  STDCardViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDCardViewController.h"
#import "STDAppDelegate.h"

@interface STDCardViewController ()

@property (nonatomic, strong) STHTTPNetwork * network;

@end

@implementation STDCardViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString * URLString = [STDAppDelegate sinaappCorrectionEnabled] ? @"http://www.lovecard.vipsinaapp.com" : @"http://www.lovecard.sinaapp.com";
        self.network = [[STHTTPNetwork alloc] initWithHost:URLString path:@"open"];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明信片";
}

- (void) loadDataWithPage:(NSInteger)page size:(NSInteger)size completionHandler:(STDFeedLoadHandler)completionHandler {
    NSDictionary * parameters = @{@"page":@(page), @"size":@(size)};
    [self.network sendAsynchronousRequestWithMethod:@"photo/list/" parameters:parameters handler:^(STNetworkOperation * operation, id response, NSError *error) {
        if (!error) {
            NSMutableArray * result = [NSMutableArray arrayWithCapacity:2];
            NSArray * array = [response objectForKey:@"photos"];
            BOOL hasMore = [[response objectForKey:@"more"] boolValue] && array.count > 0;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                STDFeedItem * feedItem = [[STDFeedItem alloc] initWithDictinoary:obj];
                [result addObject:feedItem];
            }];
            if (completionHandler) {
                completionHandler([result copy], hasMore, nil);
            }
        } else {
            if (completionHandler) {
                completionHandler(nil, NO, error);
            }
        }
    }];
}

@end

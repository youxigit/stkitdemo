//
//  STImageView.h
//  STKit
//
//  Created by SunJiangting on 13-11-26.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>
#import <UIKit/UIKit.h>

typedef enum STImageViewState {
    STImageViewStateNormal,
    STImageViewStateDownloadError,
    STImageViewStateDownloadFinished,
} STImageViewState;

@class STRoundProgressView;
@interface STImageView : UIImageView

@property (nonatomic, readonly) STRoundProgressView * progressView;

@property (nonatomic, copy)     NSString            * URLString;
@property (nonatomic, assign)   BOOL                  showProgressWhenLoading;

@end

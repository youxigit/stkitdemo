//
//  TVImageChooseCell.h
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVImageChooseDelegate <NSObject>

- (void) imageChooseActionFiredWithSender:(UIButton *) chooseButton;

@end

@interface TVImageChooseCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UIButton * chooseButton;

@property (nonatomic, weak) id<TVImageChooseDelegate> delegate;

@end

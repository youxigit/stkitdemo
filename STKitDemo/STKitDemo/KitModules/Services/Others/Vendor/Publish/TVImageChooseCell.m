//
//  TVImageChooseCell.m
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVImageChooseCell.h"

@interface TVImageChooseCell ()
/// 选择图片的按钮
@property (nonatomic, strong) UIButton * chooseButton;

@end

@implementation TVImageChooseCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chooseButton addTarget:self action:@selector(chooseActionFired:) forControlEvents:UIControlEventTouchUpInside];
        self.chooseButton.frame = self.bounds;
        self.chooseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.chooseButton setImage:[UIImage imageNamed:@"choose_image_normal.png"] forState:UIControlStateNormal];
        [self.chooseButton setImage:[UIImage imageNamed:@"choose_image_highlighted.png"] forState:UIControlStateHighlighted];
        [self addSubview:self.chooseButton];
    }
    return self;
}

- (void) chooseActionFired:(id) sender {
    if ([self.delegate respondsToSelector:@selector(imageChooseActionFiredWithSender:)]) {
        [self.delegate imageChooseActionFiredWithSender:self.chooseButton];
    }
}

@end

//
//  TVPublishToolbar.m
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVPublishToolbar.h"

@interface TVPublishToolbar ()

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIButton    * actionButton;

@end

@implementation TVPublishToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage * backgroundImage = [[UIImage imageNamed:@"publish_tool_bkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 5, 20, 5) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageView.image = backgroundImage;
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundImageView];
        
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = CGRectMake(10, 12, 300, 40);
        UIImage * btnImage = [[UIImage imageNamed:@"publish_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        UIImage * disabledImage = [[UIImage imageNamed:@"publish_button_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        [self.actionButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self.actionButton setBackgroundImage:disabledImage forState:UIControlStateDisabled];
        [self.actionButton setTitle:@"发布新品" forState:UIControlStateNormal];
        [self addSubview:self.actionButton];
    }
    return self;
}

@end

//
//  TVImageView.m
//  STKitDemo
//
//  Created by SunJiangting on 14-1-13.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVImageView.h"
#import <STKit/STKit.h>

@interface TVImageView () {
    NSInvocation * _invocation;
}

@property (nonatomic, strong) UIView * maskView;

@end

@implementation TVImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.maskView.backgroundColor = [UIColor colorWithRGB:0 alpha:0.5];
        self.maskView.hidden = YES;
        [self addSubview:self.maskView];
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.maskView.hidden = NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.maskView.hidden = YES;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.maskView.hidden = YES;
}
@end

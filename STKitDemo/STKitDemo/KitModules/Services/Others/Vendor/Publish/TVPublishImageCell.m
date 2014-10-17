//
//  TVPublishImageCell.m
//  Vendor
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVPublishImageCell.h"
#import <STKit/STKit.h>

@interface TVPublishImageCell ()

@property (nonatomic,  strong) UIImageView * imageView;
@property (nonatomic, strong) UIView      * highlightedView;

@end

const CGSize TVPublishImageDefaultSize = {64, 64};

@implementation TVPublishImageCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
        
        self.highlightedView = [[UIView alloc] initWithFrame:self.imageView.frame];
        self.highlightedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.highlightedView.backgroundColor = [UIColor colorWithRGB:0x0 alpha:0.5];
        self.highlightedView.userInteractionEnabled = NO;
        [self addSubview:self.highlightedView];
        self.highlightedView.hidden = YES;
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.highlightedView.hidden = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.highlightedView.hidden = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.highlightedView.hidden = YES;
}

@end

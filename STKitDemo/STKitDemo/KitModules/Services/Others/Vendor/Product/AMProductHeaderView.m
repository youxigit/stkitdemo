//
//  AMProductHeaderView.m
//  AlibabaMobile
//
//  Created by SunJiangting on 13-12-13.
//
//

#import "AMProductHeaderView.h"

@interface AMProductHeaderView ()

@property (nonatomic, retain) UILabel  * textLabel;

@end

const CGSize AMProductHeaderDefaultSize = {320, 30};
@implementation AMProductHeaderView

- (void) dealloc {
    self.textLabel = nil;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (frame.size.width == 0) {
        frame.size = AMProductHeaderDefaultSize;
    }
    if (frame.size.height == 0) {
        frame.size.height = 10;
    }
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width - 20, height - 20)];
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void) setProductText:(NSString *) productText {
    [self willChangeValueForKey:@"productText"];
    _productText = [productText copy];
    self.textLabel.text = _productText;
    [self headerSizeToFit];
    [self didChangeValueForKey:@"productText"];
}

- (void) headerSizeToFit {
    CGFloat width = CGRectGetWidth(self.textLabel.bounds);
    CGSize size = [_productText sizeWithFont:self.textLabel.font
                           constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                               lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width + 20, size.height + 20);
    self.frame = frame;
}

@end

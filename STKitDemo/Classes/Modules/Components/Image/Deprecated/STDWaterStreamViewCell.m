//
//  SPhotoRemoteViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-11-13.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "STDWaterStreamViewCell.h"

#import <STKit/STKit.h>

#define kMinCellRect CGRectMake(0,0,30,30)

static NSString * kUnIdentifier = @"UnIdentifier";

@interface STDWaterStreamViewCell ()

@property (nonatomic, strong) UIView      * selectedView;

@end

@implementation STDWaterStreamViewCell

- (void) dealloc {
    
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = kMinCellRect;
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.photoImageView.clipsToBounds = YES;
        [self addSubview:self.photoImageView];
        
        self.selectedView = [[UIView alloc] initWithFrame:self.photoImageView.frame];
        self.selectedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectedView.backgroundColor = [UIColor colorWithRGB:0x0 alpha:0.5];
        self.selectedView.userInteractionEnabled = NO;
        [self addSubview:self.selectedView];
        self.selectedView.hidden = YES;
    }
    return self;
}

- (void) setPhotoDictionary:(NSDictionary *)photoDictionary {
    NSString * imageString = [photoDictionary objectForKey:@"thumb"];
    if (![[_photoDictionary valueForKey:@"thumb"] isEqualToString:imageString]) {
        [self.photoImageView setImageWithURLString:imageString];
    }
    _photoDictionary = photoDictionary;
}

- (void) prepareForReuse {
    [super prepareForReuse];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.selectedView.hidden = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.selectedView.hidden = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.selectedView.hidden = YES;
}

@end

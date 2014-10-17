//
//  TVProductCell.m
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVProductCell.h"
#import "TVProductItem.h"

#import "TVImageView.h"

#import <STKit/STKit.h>

@interface TVProductCell ()

@property (nonatomic, strong) TVImageView * thumbView;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UILabel     * priceLabel;
@property (nonatomic, strong) UILabel     * placeLabel;
@property (nonatomic, strong) UILabel     * publishLabel;

@end

const CGSize    TVProductDefaultCellSize = {320, 122};
const CGSize    TVProductDefaultThumbSize = {81, 81};
const CGFloat   TVProductDefaultVerticalMargin = 10;

@implementation TVProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, TVProductDefaultCellSize.width, TVProductDefaultCellSize.height);
        
        self.selectedBackgroundView = UIView.new;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRGB:0x0 alpha:0.25];
        
        UIView * thumbBkgView = [[UIView alloc] initWithFrame:CGRectMake(TVProductDefaultVerticalMargin, TVProductDefaultVerticalMargin, TVProductDefaultThumbSize.width, TVProductDefaultThumbSize.height)];
        thumbBkgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:thumbBkgView];
        
        self.thumbView = [[TVImageView alloc] initWithFrame:CGRectMake(3, 3, TVProductDefaultThumbSize.width - 6, TVProductDefaultThumbSize.height - 6)];
        self.thumbView.clipsToBounds = YES;
        self.thumbView.userInteractionEnabled = YES;
        self.thumbView.contentMode = UIViewContentModeScaleAspectFill;
        [self.thumbView addTouchTarget:self action:@selector(imageTouched:)];
        self.thumbView.placeholderImage = [UIImage imageNamed:@"product_default.png"];
        [thumbBkgView addSubview:self.thumbView];
        
        CGFloat contentOffsetX = CGRectGetMaxY(thumbBkgView.frame) + 5;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, 10, TVProductDefaultCellSize.width - contentOffsetX - TVProductDefaultVerticalMargin, 38)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:0x33/255. green:0x33/255. blue:0x33/255. alpha:1.0];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, 50, 200, 18)];
        self.priceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont systemFontOfSize:16.];
        self.priceLabel.textColor = [UIColor colorWithRed:0xcc/255. green:0 blue:0 alpha:1.0];
        [self addSubview:self.priceLabel];
        
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, 76, 200, 14)];
        self.placeLabel.font = [UIFont systemFontOfSize:12.];
        self.placeLabel.textColor = [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:1.0];
        self.placeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.placeLabel];
        
        self.publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentOffsetX, 95, 200, 14)];
        self.publishLabel.backgroundColor = [UIColor clearColor];
        self.publishLabel.font = [UIFont systemFontOfSize:12.];
        self.publishLabel.textColor = [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:1.0];
        [self addSubview:self.publishLabel];
    }
    return self;
}

- (void) imageTouched:(id) sender {
    if (self.productItem.images.count > 0) {
        TVImageItem * image = self.productItem.images[0];
        if ([self.delegate respondsToSelector:@selector(didFiredImageAction:imageItem:)]) {
            [self.delegate didFiredImageAction:self.thumbView imageItem:image];
        }
    }
}

- (void) setProductItem:(TVProductItem *)productItem {
    
    self.titleLabel.text = productItem.title;
    if (productItem.price <= 0) {
        productItem.price = (rand() % 10000) / 100 + 10;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f / %@", productItem.price, productItem.unit];
    self.placeLabel.text = [NSString stringWithFormat:@"%@ %@", productItem.province, productItem.city];
    self.publishLabel.text = productItem.time;
    if (productItem.images.count > 0) {
        TVImageItem * image = productItem.images[0];
        [self.thumbView setImageWithURLString:image.thumbURL];   
    }
    
    _productItem = productItem;
}

- (void) prepareForReuse {
    [super prepareForReuse];
}

+ (NSString *)  defaultProductCellIdentifier {
    return @"TVProductCellDefaultIdenfitier";
}

+ (CGFloat) defaultProductCellHeight {
    return TVProductDefaultCellSize.height;
}

@end

//
//  TVProductCell.h
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TVImageItem;
@protocol TVProductCellDelegate <NSObject>

- (void) didFiredImageAction:(UIImageView *) imageView imageItem:(TVImageItem *) imageItem;

@end

@class TVProductItem;
@interface TVProductCell : UITableViewCell

@property (nonatomic, readonly, strong) UIImageView * thumbView;
@property (nonatomic, readonly, strong) UILabel     * titleLabel;
@property (nonatomic, readonly, strong) UILabel     * priceLabel;
@property (nonatomic, readonly, strong) UILabel     * placeLabel;
@property (nonatomic, readonly, strong) UILabel     * publishLabel;

@property (nonatomic, strong) TVProductItem * productItem;
@property (nonatomic, weak)   id <TVProductCellDelegate> delegate;

+ (NSString *)  defaultProductCellIdentifier;
+ (CGFloat)     defaultProductCellHeight;

@end
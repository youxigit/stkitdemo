//
//  AMProductCell.h
//  AlibabaMobile
//
//  Created by SunJiangting on 13-12-13.
//
//

#import <UIKit/UIKit.h>

@class TVImageItem;
@protocol AMProductCellDelegate <NSObject>

- (void) thumbImageViewDidTouchedWithImageItem:(TVImageItem *) imageItem;

@end
@class TVProductItem, TVImageView;
@interface AMProductCell : UITableViewCell

@property (nonatomic, readonly, strong) TVImageView * thumbView;

@property (nonatomic, strong) TVImageItem * imageItem;
@property (nonatomic, weak) id <AMProductCellDelegate> delegate;

+ (NSString *)  defaultProductCellIdentifier;
+ (CGFloat) heightForCellWithImageItem:(TVImageItem *) imageItem;

@end

//
//  AMProductCell.m
//  AlibabaMobile
//
//  Created by SunJiangting on 13-12-13.
//
//

#import "AMProductCell.h"
#import <STKit/STKit.h>
#import "TVProductItem.h"
#import "TVImageView.h"


@interface AMProductCell ()

@property (nonatomic, strong) UIImageView       * borderImageView;
@property (nonatomic, strong) TVImageView       * thumbView;

@end

const CGSize AMProductDefaultCellSize = {320, 30};

@implementation AMProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, AMProductDefaultCellSize.width, AMProductDefaultCellSize.height);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, AMProductDefaultCellSize.width - 20, AMProductDefaultCellSize.height - 10)];
        self.borderImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.borderImageView.backgroundColor = [UIColor whiteColor];
        self.borderImageView.userInteractionEnabled = YES;
        
        [self addSubview:self.borderImageView];
        
        self.thumbView = [[TVImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.borderImageView.bounds) - 8, CGRectGetHeight(self.borderImageView.bounds) - 8)];
        self.thumbView.clipsToBounds = YES;
        self.thumbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.thumbView.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbView.userInteractionEnabled = YES;
        [self.borderImageView addSubview:self.thumbView];
        self.thumbView.placeholderImage = [UIImage imageNamed:@"shangxin_292182.jpg"];
        [self.thumbView addTouchTarget:self action:@selector(thumbViewDidTouched:)];
    }
    return self;
}

- (void) setImageItem:(TVImageItem *) imageItem {
    if ([STImageCache hasCachedImageForKey:imageItem.imageURL]) {
        [self.thumbView setImageWithURLString:imageItem.imageURL];
    } else {
        [self.thumbView setImageWithURLString:imageItem.thumbURL];
    }
    _imageItem = imageItem;
}

- (void) thumbViewDidTouched:(id) sender {
    if ([self.delegate respondsToSelector:@selector(thumbImageViewDidTouchedWithImageItem:)]) {
        [self.delegate thumbImageViewDidTouchedWithImageItem:self.imageItem];
    }
}

+ (NSString *)  defaultProductCellIdentifier {
    return @"AMDefaultProductCellIdentifier";
}

#pragma mark - CellHeight
+ (CGFloat) heightForCellWithImageItem:(TVImageItem *) imageItem {
    CGFloat width = 292;
    CGFloat productWidth = imageItem.width;
    CGFloat productHeight = imageItem.height;
    CGFloat height = width * productHeight / productWidth;
    return height + 20;
}

@end

//
//  TVProductItem.h
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STItem <NSObject>

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

- (NSDictionary *) toDictionary;

@end

@interface TVImageItem : NSObject <STItem>

@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, copy) NSString * thumbURL;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@interface TVProductItem : NSObject<STItem>

@property (nonatomic, copy) NSString * productID;
@property (nonatomic, copy) NSString * title;
/// (product 价格)
@property (nonatomic, assign) CGFloat  price;
// (交易计量单位，跟销量一起用)
@property (nonatomic, copy) NSString * unit;
// (卖家所在省份)
@property (nonatomic, copy) NSString * province;
//  (卖家所在城市)
@property (nonatomic, copy) NSString * city;
//  (上次行为时间，为本次需求新增)
@property (nonatomic, copy) NSString * time;

@property (nonatomic, copy) NSMutableArray * images;

@end

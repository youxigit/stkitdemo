//
//  TVProductItem.m
//  Vendor
//
//  Created by SunJiangting on 14-1-6.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TVProductItem.h"

@implementation TVImageItem

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        NSString * prefix = @"http://bcs.duapp.com/vendor";
        id imageURLValue = [dictionary valueForKey:@"imageURL"];
        if (imageURLValue) {
            self.imageURL = [NSString stringWithFormat:@"%@%@", prefix, imageURLValue];
        }
        id thumbURLValue = [dictionary valueForKey:@"thumbURL"];
        if (thumbURLValue) {
            self.thumbURL = [NSString stringWithFormat:@"%@%@", prefix, thumbURLValue];
        }
        self.width = [[dictionary valueForKey:@"width"] floatValue];
        self.height = [[dictionary valueForKey:@"height"] floatValue];
    }
    return self;
}

- (NSDictionary *) toDictionary {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    [dictionary setValue:self.imageURL forKey:@"imageURL"];
    [dictionary setValue:self.thumbURL forKey:@"thumbURL"];
    [dictionary setValue:@(self.width) forKey:@"width"];
    [dictionary setValue:@(self.height) forKey:@"height"];
    return dictionary;
}

@end

@implementation TVProductItem

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        id productValue = [dictionary valueForKey:@"productID"];
        if (productValue) {
            self.productID = [NSString stringWithFormat:@"%@", productValue];
        }
        self.title = [dictionary valueForKey:@"title"];
        if (!self.title) {
            self.title = @"豪训直供 冬季电动车挡风被 摩托车挡风护膝护理 电瓶车挡风被";
        }
        self.price = [[dictionary valueForKey:@"price"] floatValue];
        self.unit = [dictionary valueForKey:@"unit"];
        if (!self.unit) {
            self.unit = @"件";
        }
        self.province = [dictionary valueForKey:@"province"];
        self.city = [dictionary valueForKey:@"city"];
        self.time = [dictionary valueForKey:@"time"];
    
        NSArray * array = [dictionary valueForKey:@"images"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray * images = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                TVImageItem * imageItem = [[TVImageItem alloc] initWithDictionary:obj];
                [images addObject:imageItem];
            }];
            self.images = images;
        }
        
    }
    return self;
}

- (NSDictionary *) toDictionary {
    return nil;
}

@end

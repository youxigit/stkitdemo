//
//  STDFactory.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDFactoryPatterns.h"

@protocol STDCompanyProtocol;
/**
 * @abstract 　　工厂方法模式（Factory Method），定义一个用于创建对象的接口，让子类决定实例化哪一个类。工厂方法使一个类的实例化延迟到其子类。说的通俗一点吧，就是把将工厂类抽象成接口，具体的代工厂去实现此接口，同时把产品类也抽象成接口，再构造具体的产品去实现些接口
 */
@interface STDFactory : NSObject <STDesignPatternsDelegate>

+ (id <STDCompanyProtocol>)createCompany;

@end

@interface STDAppleFactory : STDFactory

@end

@interface STDGoogleFactory : STDFactory

@end

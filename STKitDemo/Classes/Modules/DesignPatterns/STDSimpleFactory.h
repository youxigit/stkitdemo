//
//  STDSimpleFactory.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDFactoryPatterns.h"

typedef NS_ENUM(NSInteger, STDCompanyType) {
    STDCompanyTypeApple,
    STDCompanyTypeGoogle,
};

/**
 * @abstract 简单工厂模式在开发中应用的情况也非常多，但其并不是GOF二十三种设计模式之一，最多只能算作是工厂方法模式的一种特殊形式，从设计模式的类型上来说，简单工厂模式是属于创建型模式，又叫做静态工厂方法（Static Factory Method）模式。
 * @li 简单工厂模式的实质是由一个工厂类根据传入的参数，动态决定应该创建哪一个产品类（这些产品类继承自一个父类或接口）的实例
 */

@interface STDSimpleFactory : NSObject <STDesignPatternsDelegate>

+ (id<STDCompanyProtocol>)createCompanyWithType:(STDCompanyType) type;

@end
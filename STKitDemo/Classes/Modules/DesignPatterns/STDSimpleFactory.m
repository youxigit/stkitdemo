//
//  STDSimpleFactory.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDSimpleFactory.h"


@implementation STDSimpleFactory

+ (id<STDCompanyProtocol>)createCompanyWithType:(STDCompanyType) type {
    if (type == STDCompanyTypeApple) {
        return STDCompanyApple.new;
    }
    return STDCompanyGoogle.new;
}

+ (void)test {
    STDCompanyApple *companyApple = [STDSimpleFactory createCompanyWithType:STDCompanyTypeApple];
    [companyApple printCompanyName];
    
    STDCompanyGoogle *companyGoogle = [STDSimpleFactory createCompanyWithType:STDCompanyTypeGoogle];
    [companyGoogle printCompanyName];
}

- (void)printDesignPatternName {
    NSLog(@"简单工厂模式");
}

- (void)printAdvantages {
    NSLog(@"\n优点：\n通过使用工厂类，外界不再需要关心如何创造各种具体的产品，只要提供一个产品的名称作为参数传给工厂，就可以直接得到一个想要的产品对象，并且可以按照接口规范@来调用产品对象的所有功能（方法）。\n构造容易，逻辑简单。");
}

- (void)printDisadvantages {
    NSLog(@"\n缺点：\n\t1.细心的朋友可能早就发现了，这么多if else判断完全是Hard Code啊，如果我有一个新产品要加进来，就要同时添加一个新产品类，并且必须修改工厂类，再加入一个 else if 分支才可以， 这样就违背了 “开放-关闭原则”中的对修改关闭的准则了。当系统中的具体产品类不断增多时候，就要不断的修改工厂类，对系统的维护和扩展不利。那有没有改进的方法呢？在工厂方法模式中会进行这方面的改进。\n\t2.一个工厂类中集合了所有的类的实例创建逻辑，违反了高内聚的责任分配原则，将全部的创建逻辑都集中到了一个工厂类当中，因此一般只在很简单的情况下应用，比如当工厂类负责创建的对象比较少时。");
}


@end

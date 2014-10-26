//
//  STBGameLayer.h
//  STBBoxMan
//
//  Created by SunJiangting on 12-12-8.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "STBMapLayer.h"

@interface STBGameLayer : CCLayer <STBGameDelegate>

+ (CCScene *) scene;

@property (nonatomic, assign) NSInteger level;

@end

//
//  STBThumbLayer.h
//  STBBoxMan
//
//  Created by SunJiangting on 13-1-5.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "STBLevel.h"

@interface STBThumbLayer : CCLayer

+ (id) thumbLayerWithLevel:(STBLevel *) level;

- (id) initWithLevel:(STBLevel *) level;

@end

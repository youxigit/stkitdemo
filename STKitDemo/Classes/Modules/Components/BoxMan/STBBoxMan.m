//
//  STBBoxMan.m
//  STBBoxMan
//
//  Created by SunJiangting on 12-12-6.
//
//

#import "STBBoxMan.h"

@implementation STBBoxMan

- (id) initWithPosition:(CGPoint) position {
    self = [super initWithFile:@"man_baby.png"];
    if (self) {
        self.position = position;
        self.direction = STBDirectionDown;
    }
    return self;
}

- (void) setDirection:(STBDirection)direction {
    if (direction != _direction ) {
        // TODO:设置方向
        NSString * imageName = @"man_baby.png";
        switch (direction) {
            case STBDirectionUp:
                imageName = @"man_baby_up.png";
                break;
            case STBDirectionDown:
                imageName = @"man_baby_down.png";
                break;
            case STBDirectionLeft:
                imageName = @"man_baby_left.png";
                break;
            case STBDirectionRight:
                imageName = @"man_baby_right.png";
                break;
            default:
                break;
        }
        CCSprite * sprite = [CCSprite spriteWithFile:imageName];
        self.texture = sprite.texture;
        _direction = direction;
    }
    
}


@end

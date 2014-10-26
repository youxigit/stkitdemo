//
//  STBGameLayer.m
//  STBBoxMan
//
//  Created by SunJiangting on 12-12-8.
//
//

#import "STBGameLayer.h"
#import "IntroLayer.h"

@interface STBGameLayer ()

@property(nonatomic, strong) STBMapLayer *mapLayer;

@property(nonatomic, strong) CCMenuItemFont *levelItemFont;
@property(nonatomic, assign) NSInteger levelCount;
@property(nonatomic, strong) CCMenuItemFont *stepItemFont;
@property(nonatomic, assign) NSInteger stepCount;

@end

@implementation STBGameLayer

+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    STBGameLayer *gameLayer = [STBGameLayer node];
    gameLayer.contentSize = [CCDirector sharedDirector].winSize;
    [scene addChild:gameLayer];
    return scene;
}

- (void)dealloc {
    [_stepItemFont release];
    [_mapLayer release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *sprite = [CCSprite spriteWithFile:@"background.png"];
        sprite.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        sprite.scaleX = 2; //设置精灵宽度缩放比例
        sprite.scaleY = 2;
        [self addChild:sprite];

        self.mapLayer = [STBMapLayer node];
        self.mapLayer.delegate = self;
        [self.mapLayer loadMapWithLevel:[STBLevelManager standardLevelManager].level];
        [self addChild:self.mapLayer z:1];

        CCMenuItemImage *bkgItemImage = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png"];
        bkgItemImage.position = CGPointMake(0, 0);
        CCMenu *bkgMenu = [CCMenu menuWithItems:bkgItemImage, nil];
        bkgMenu.position = CGPointMake(winSize.width / 2, winSize.height - 15);
        [self addChild:bkgMenu z:5];

        self.levelItemFont = [CCMenuItemFont itemWithString:@"正在加载"];
        self.levelItemFont.position = CGPointMake(40, 0);
        self.levelItemFont.scale = 0.6f;
        self.levelItemFont.color = ccYELLOW;
        self.levelCount = [STBLevelManager standardLevelManager].currentLevel;

        self.stepItemFont = [CCMenuItemFont itemWithString:@"正在加载"];
        self.stepItemFont.scale = 0.6f;
        self.stepItemFont.color = ccYELLOW;
        self.stepItemFont.position = CGPointMake(200, 0);
        self.stepCount = 0;

        CCMenu *upperMenu = [CCMenu menuWithItems:self.levelItemFont, self.stepItemFont, nil];
        upperMenu.position = CGPointMake(30, winSize.height - 15);
        [self addChild:upperMenu z:5 tag:1];

        CCMenuItemImage *prevLevel =
            [CCMenuItemImage itemWithNormalImage:@"previous.png"
                                   selectedImage:@"previous.png"
                                           block:^(id sender) {
                                               if ([[STBLevelManager standardLevelManager] hasPrevLevel]) {
                                                   [self.mapLayer loadMapWithLevel:[[STBLevelManager standardLevelManager] prevLevel]];
                                                   self.levelCount = [STBLevelManager standardLevelManager].currentLevel;
                                               }
                                           }];
        prevLevel.position = CGPointMake(0, 0);

        CCMenuItemImage *nextLevel =
            [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next.png" block:^(id sender) { [self nextLevel]; }];
        nextLevel.position = CGPointMake(40, 0);

        CCMenuItemImage *resetLevel =
            [CCMenuItemImage itemWithNormalImage:@"reset.png" selectedImage:@"reset.png" block:^(CCMenuItemImage * sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[IntroLayer scene] withColor:ccWHITE]];
                if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
                    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                }
                
            }];
        resetLevel.position = CGPointMake(80, 0);

        CCMenu *menu = [CCMenu menuWithItems:prevLevel, nextLevel, resetLevel, nil];
        menu.position = CGPointMake(winSize.width - 140, winSize.height - 15);
        [self addChild:menu z:5 tag:1];
    }
    return self;
}

- (void)nextLevel {
    if ([[STBLevelManager standardLevelManager] hasNextLevel]) {
        STBLevel *level = [[STBLevelManager standardLevelManager] nextLevel];
        [self.mapLayer loadMapWithLevel:level];
        self.levelCount = [STBLevelManager standardLevelManager].currentLevel;
    }
}

- (void)setLevelCount:(NSInteger)levelCount {
    NSString *string = [NSString stringWithFormat:@"Level : %d", levelCount + 1];
    [self.levelItemFont setString:string];
    _levelCount = levelCount;
}

- (void)setStepCount:(NSInteger)stepCount {
    NSString *string = [NSString stringWithFormat:@"%03d", stepCount];
    [self.stepItemFont setString:string];
    _stepCount = stepCount;
}

- (void)gameDidStart {

    self.stepCount = 0;
}

- (void)gameDidFinish {
    [self performSelector:@selector(nextLevel) withObject:nil afterDelay:1.0f];
}

- (void)boxManDidMovedWithBox:(BOOL)withBox {
    self.stepCount++;
}
@end

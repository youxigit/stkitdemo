//
//  IntroLayer.m
//  SBoxMan
//
//  Created by SunJiangting on 12-12-6.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "STBGameLayer.h"
#import "STBWindow.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

- (void)dealloc {
    
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.contentSize = winSize;
        
        NSMutableArray * layers = [NSMutableArray arrayWithCapacity:5];
        NSArray * levels = [STBLevelManager standardLevelManager].levelArray;
        for (STBLevel * level in levels) {
            STBThumbLayer * layer = [STBThumbLayer thumbLayerWithLevel:level];
            [layers addObject:layer];
        }
        
        __block CCScrollLayer * scrollLayer = [CCScrollLayer nodeWithLayers:layers layerWidth:233 widthOffset:40];
        scrollLayer.anchorPoint = ccp(0, 0);
        scrollLayer.position = ccp(0, 90);
        [scrollLayer selectPage:0];
        
        [self addChild:scrollLayer z:5];
        
        CCSprite * background = [CCSprite spriteWithFile:@"background.png"];
        background.contentSize = winSize;
        background.anchorPoint = ccp(0, 0);
        background.position = CGPointMake(0, 0);
        background.scaleX = 2; //设置精灵宽度缩放比例
        background.scaleY = 2;
        [self addChild:background z:0 tag:1];
        
        CCMenuItemFont *backLabel = [CCMenuItemFont itemWithString:@"返回" block:^(id sender) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [[STBLoader defaultLoader] unloadBoxManAnimated:YES]; 
            });
        }];
        backLabel.scale = 0.6f;
        backLabel.color = ccYELLOW;
        CCMenu *upperMenu = [CCMenu menuWithItems:backLabel, nil];
        upperMenu.position = CGPointMake(40, 40);
        [self addChild:upperMenu z:5 tag:1];

        
        CCMenuItemImage * startItem = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start.png" block:^(id sender) {
            [STBLevelManager standardLevelManager].currentLevel = scrollLayer.currentScreen;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[STBGameLayer scene] withColor:ccWHITE]];
        }];
        startItem.position = CGPointMake(0, 0);
        CCMenu * menu = [CCMenu menuWithItems:startItem, nil];
        CGFloat height = winSize.width < winSize.height ? winSize.height : winSize.width;
        menu.position = CGPointMake(height / 2, 40);
        [self addChild:menu];
    }
    return self;
}

// 
-(void) onEnter
{
	[super onEnter];
}

@end

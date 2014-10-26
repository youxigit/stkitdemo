//
//  STBWindow.m
//  STKitDemo
//
//  Created by SunJiangting on 14-10-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STBWindow.h"

#import "cocos2d.h"
#import "IntroLayer.h"
#import <STKit/STKit.h>


@interface STBWindow () <CCDirectorDelegate>

- (void)unloadCocos2d;

@end

@interface STBLoader ()

@property (nonatomic, strong) STBWindow * window;

@end
@implementation STBLoader

static STBLoader *_loader;
+ (instancetype)defaultLoader {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loader = [[self alloc] init];
    });
    return _loader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadBoxManAnimated:(BOOL)animated {
    if (self.window) {
        return;
    }
    STBWindow * window = [[STBWindow alloc] init];
    [window makeKeyAndVisible];
    void(^animations)(void) = ^{
        window.alpha = 1.0;
    };
    if (animated) {
        window.alpha = 0.5;
        [UIView animateWithDuration:0.5 animations:animations];
    }
    self.window = window;
}

- (void)unloadBoxManAnimated:(BOOL)animated {
    [self.window unloadCocos2d];
    void(^animations)(void) = ^{
        self.window.alpha = .5;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
        self.window = nil;
    };
    if (animated) {
        [UIView animateWithDuration:0.5 animations:animations completion:completion];
    } else {
        completion(YES);
    }
}

@end


@implementation STBWindow {
    BOOL _load;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)unloadCocos2d {
    if (_load) {
        _load = NO;
        [[CCDirector sharedDirector] stopAnimation];
        [[CCDirector sharedDirector] purgeCachedData];
        [CCDirector sharedDirector].view = nil;
        [CCDirector sharedDirector].delegate = nil;
        [self removeAllSubviews];
        CC_DIRECTOR_END();
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)loadCocos2d {
    if (!_load) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        CGSize size = self.bounds.size;
        if (size.width > size.height) {
            CGFloat width = size.width;
            size.width = size.height;
            size.height = width;
        }
        _load = YES;
        // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
        CCGLView *glView = [CCGLView viewWithFrame:CGRectMake(0, 0, size.width, size.height)
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        // Display FSP and SPF
        [[CCDirector sharedDirector] setDisplayStats:NO];
        
        // set FPS at 60
        [[CCDirector sharedDirector] setAnimationInterval:1.0/60];
        
        // attach the openglView to the director
        glView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [[CCDirector sharedDirector] setView:glView];
        
        //         for rotation and other messages
        [[CCDirector sharedDirector] setDelegate:self];
        
        // 2D projection
        [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
        if( ! [[CCDirector sharedDirector] enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
        
        // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
        // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
        // You can change anytime.
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        // If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
        // On iPad HD  : "-ipadhd", "-ipad",  "-hd"
        // On iPad     : "-ipad", "-hd"
        // On iPhone HD: "-hd"
        CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
        [sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
        [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"@2x"];		// Default on iPhone RetinaDisplay is "-hd"
        [sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
        [sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
        
        // Assume that PVR images have premultiplied alpha
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        // and add the scene to the stack. The director will run it when it automatically when the view is displayed.
        [[CCDirector sharedDirector] pushScene: [IntroLayer scene]];
        [self addSubview:glView];
        glView.transform = CGAffineTransformMakeRotation(M_PI_2);
        glView.frame = self.bounds;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationSignificantTimeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
}

- (instancetype) initWithFrame:(CGRect)frame {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width > size.height) {
        CGFloat width = size.width;
        size.width = size.height;
        size.height = width;
    }
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        [self loadCocos2d];
    }
    return self;
}


- (void)makeKeyAndVisible {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [super makeKeyAndVisible];
    [keyWindow makeKeyWindow];
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application {
        [[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application {
        [[CCDirector sharedDirector] resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
        [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
        [[CCDirector sharedDirector] startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end

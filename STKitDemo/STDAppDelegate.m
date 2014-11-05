//
//  STDAppDelegate.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-6.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDAppDelegate.h"

#import "STDSideBarController.h"
#import "STDLeftViewController.h"
#import "STDTabBarController.h"

#import "STDStartViewController.h"

#import <STKit/STKit.h>
#import <STKit/STNotificationWindow.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import "MobClick.h"
#import "STDVoiceWindow.h"
#import "SCSiriWaveformView.h"
#import "STDWXVoiceRecognizer.h"
#import "FLEXManager.h"
#import "STLocalServer.h"
#import "ImageMaskView.h"
#import "GesturePasswordController.h"

typedef union {
    NSInteger value;
    Byte bytes[4];
} STTInteger;

@interface STDAppDelegate ()<STVoiceRecognizerDelegate, STNotificationWindowDelegate, ImageMaskFilledDelegate> {
    BOOL _voiceControlOpened;
    BOOL _FLEXEnabled;
    AVAudioRecorder * _audioRecorder;
    NSDate          * _previousEnterBackgroundTime;
    BOOL              _needRemovePasswordView;
}

@property (nonatomic, strong) NSArray              * appids;

@property (nonatomic, strong) STDWXVoiceRecognizer * voiceRecognizer;

@property (nonatomic, strong) STNotificationWindow * notificationWindow;
@property (nonatomic, strong) GesturePasswordController * passwordController;
@end

@implementation STDAppDelegate

+ (BOOL)boxManEnabled {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"BoxManEnabled"] boolValue];
}

+ (BOOL) sinaappCorrectionEnabled {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"sinaappHostEnabled"] boolValue];
}

+ (void) displayNotificationWith:(NSString *) name title:(NSString *) title {
    STDAppDelegate * delegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegate isKindOfClass:[STDAppDelegate class]]) {
        [delegate displayNotificationWith:name title:title];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleDefault;
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString * previousStyle = [[STPersistence standardPerstence] valueForKey:@"SelectedStyle"];
    if ([previousStyle isEqualToString:@"TabBar"]) {
        self.window.rootViewController = [self tabBarController];
    } else if ([previousStyle isEqualToString:@"SideBar"]) {
        self.window.rootViewController = [self sideBarController];
    } else {
        self.window.rootViewController = [self startViewController];
    }
    [self.window makeKeyAndVisible];
    [self initializeCustomUserSetting];
    if (![[[STPersistence standardPerstence] valueForKey:@"ST-GuideLaunchView"] boolValue]) {
        [self addLaunchView];
        [[STPersistence standardPerstence] setValue:@(YES) forKey:@"ST-GuideLaunchView"];
    } else {
        GesturePasswordController * passwordController = [[GesturePasswordController alloc] init];
        passwordController.view.frame = self.window.bounds;
        [self.window addSubview:passwordController.view];
        self.passwordController = passwordController;
    }
    
    return YES;
}

- (void) addLaunchView {
    UIImage * launchImage = [UIImage imageNamed:@"LaunchImage"];
    UIImageView * launchView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    launchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    launchView.image = launchImage;
    launchView.tag = 10001;
    [self.window addSubview:launchView];
    
    ImageMaskView * maskView = [[ImageMaskView alloc] initWithFrame:launchView.frame image:[launchImage blurImageWithStyle:STBlurEffectStyleExtraLight]];
    maskView.autoresizingMask = launchView.autoresizingMask;
    maskView.imageMaskFilledDelegate = self;
    maskView.tag = 10002;
    maskView.alpha = 0.95;
    [self.window addSubview:maskView];
}

- (void)imageMaskView:(ImageMaskView *)maskView cleatPercentWasChanged:(float)clearPercent {

}

- (void) imageMaskViewTouchesEnd:(ImageMaskView *)maskView {
    if (maskView.procentsOfImageMasked >= 70) {
        [self _removeLaunchView];
    }
}

- (void) _removeLaunchView {
    ImageMaskView * maskView = (ImageMaskView *)[self.window viewWithTag:10002];
    [maskView removeFromSuperview];
    [self performSelector:@selector(_removeLaunchViewAnimated:) withObject:@(YES) afterDelay:0.25 inModes:@[NSDefaultRunLoopMode]];
}

- (void) _removeLaunchViewAnimated:(BOOL) animated {
    UIImageView * launchView = (UIImageView *)[self.window viewWithTag:10001];
    if (animated) {
        [UIView animateWithDuration:0.65 delay:0 options:0 animations:^{
            launchView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            launchView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [launchView removeFromSuperview];
        }];
    } else {
        [launchView removeFromSuperview];
    }
}

- (UIViewController *) startViewController {
    [[STPersistence standardPerstence] setValue:@"Start" forKey:@"SelectedStyle"];
    return  STDStartViewController.new;
}

- (UIViewController *) tabBarController {
    [[STPersistence standardPerstence] setValue:@"TabBar" forKey:@"SelectedStyle"];
    STDTabBarController * tabBarController = [[STDTabBarController alloc] init];
    return tabBarController;
}

- (UIViewController *) sideBarController {
    [[STPersistence standardPerstence] setValue:@"SideBar" forKey:@"SelectedStyle"];
    STDLeftViewController * leftViewController = [[STDLeftViewController alloc] init];
    STDSideBarController * sideBarController = [[STDSideBarController alloc] initWithRootViewController:leftViewController];
    sideBarController.navigationBarHidden = YES;
    STNavigationController * navigationController = [[STNavigationController alloc] initWithRootViewController:sideBarController];
    return navigationController;
}

- (void)replaceRootViewController:(UIViewController *)newViewController
                 animationOptions:(UIViewAnimationOptions) options {
    
    UIViewController * formerViewController = self.window.rootViewController;
    if (formerViewController == newViewController) {
        return;
    }
    CGRect applicationFrame = [UIScreen mainScreen].bounds;
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    if (statusBarHeight > 20) {
        applicationFrame.origin.y += 20;
        applicationFrame.size.height -= 20;
    }
    if (STGetSystemVersion() < 7) {
        applicationFrame.origin.y = 20;
        applicationFrame.size.height -= 20;
    }
    void (^ animations)(void) = ^{
        newViewController.view.frame = applicationFrame;
    };
    void (^ completion)(BOOL) = ^(BOOL finished) {
        self.window.rootViewController = newViewController;
        newViewController.view.frame = applicationFrame;
    };
    // options 为 0 表示木有动画
    if (options == 0) {
        completion(YES);
    } else {
        animations();
        [UIView transitionFromView:formerViewController.view toView:newViewController.view duration:0.65 options:options completion:completion];
    }
}

- (void) changeWindowFrame:(CGRect) frame {
    void (^animations)(void) = ^{
        self.window.frame = frame;
        CGRect voiceFrame = frame;
        voiceFrame.origin.y = CGRectGetMaxY(frame);
        voiceFrame.size.height = [UIScreen mainScreen].bounds.size.height - voiceFrame.origin.y;
        self.voiceWindow.frame = voiceFrame;
    };
    
    [UIView animateWithDuration:0.5 animations:animations completion:NULL];
}

- (void) openVoiceWindow {
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = 480;
    _voiceControlOpened = YES;
    [self changeWindowFrame:frame];
}

- (void) hideVoiceWindow {
    _voiceControlOpened = NO;
    _notificationWindow = nil;
    [self changeWindowFrame:[UIScreen mainScreen].bounds];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [[STDVideoLocalServer defaultLocalServer] stop];
    [self.voiceRecognizer stopListening];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[STLocalServer defaultLocalServer] stop];
    _previousEnterBackgroundTime = [NSDate date];
    
    _needRemovePasswordView = !(self.passwordController.view.superview);
    
    UIImageView * imageView = (UIImageView *) [self.passwordController.view viewWithTag:10001];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:self.passwordController.view.bounds];
    } else {
        [imageView removeFromSuperview];
    }
    imageView.tag = 10001;
    UIImage * image = [self.passwordController.view.snapshotImage blurImageWithRadius:10 tintColor:nil saturationDeltaFactor:1.0];
    imageView.image = image;
    [self.passwordController.view addSubview:imageView];
    [self.window addSubview:self.passwordController.view];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [MobClick setAppVersion:version];
    [MobClick checkUpdate:@"新版提醒" cancelButtonTitle:@"先不管" otherButtonTitles:@"去更新"];
    _FLEXEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FLEXEnabled"] boolValue];
    BOOL voiceEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"voiceControlEnabled"] boolValue];
    if (!voiceEnabled) {
        if (self.voiceRecognizer) {
            [self.voiceRecognizer stopListening];
            self.voiceRecognizer.delegate = nil;
            self.voiceRecognizer = nil;
        }
        if (_voiceControlOpened) {
            [self hideVoiceWindow];
        }
    } else {
        self.voiceRecognizer = [[STDWXVoiceRecognizer alloc] init];
        self.voiceRecognizer.delegate = self;
    }
    [[STLocalServer defaultLocalServer] start];
    UIImageView * imageView = (UIImageView *) [self.passwordController.view viewWithTag:10001];
    [imageView removeFromSuperview];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_previousEnterBackgroundTime];
    if (timeInterval > 0) {
        if (!self.passwordController.view.superview) {
            [self.window addSubview:self.passwordController.view];
        }
    } else {
        if (_needRemovePasswordView) {
             [self.passwordController.view removeFromSuperview];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[STDVideoLocalServer defaultLocalServer] startLocalServer];
    [self.voiceRecognizer startListening];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (SCSiriWaveformView *) wavefromView {
    if (!_wavefromView) {
        _wavefromView = [[SCSiriWaveformView alloc] initWithFrame:CGRectZero];
        _wavefromView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _wavefromView.backgroundColor = [UIColor grayColor];
        _wavefromView.waveColor = [UIColor whiteColor];
    }
    return _wavefromView;
}

- (STDVoiceWindow *) voiceWindow {
    if (!_voiceWindow) {
        _voiceWindow = [[STDVoiceWindow alloc] initWithFrame:CGRectZero];
        _voiceWindow.windowLevel = UIWindowLevelNormal + 1;
        self.wavefromView.frame = _voiceWindow.bounds;
        [_voiceWindow addSubview:self.wavefromView];
        [_voiceWindow makeKeyAndVisible];
        [self.window makeKeyAndVisible];
    }
    return _voiceWindow;
}

- (void) displayNotificationWith:(NSString *) name title:(NSString *) title {
    STNotificationView * notificationView = [[STNotificationView alloc] init];
    notificationView.textLabel.text = name;
    notificationView.detailLabel.text = title;
    [self.notificationWindow pushNotificationView:notificationView animated:YES];
}

#pragma mark - STVoiceRecognizerDelegate
- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didRecognizeText:(NSString *) text {
    if ([text contains:@"打开语音控制"]) {
        [self openVoiceWindow];
    } else if ([text contains:@"关闭语音控制"]) {
        self.notificationWindow = nil;
        [self hideVoiceWindow];
    } else {
        if (text.length > 0) {
            if (_voiceControlOpened) {
                [self displayNotificationWith:@"语音识别结果" title:text];
            }
            NSNotification * notification = [NSNotification notificationWithName:STDVoiceRecognizerNotification object:nil userInfo: @{@"text":text}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [voiceRecognizer startListening];
    });
}

- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didFailToRecognizeWithError:(NSError *) error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [voiceRecognizer startListening];
    });
}

- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didChangeVolumn:(CGFloat) volumn {
    if (_voiceControlOpened) {
        [self.wavefromView updateWithLevel:volumn];
    }
}

- (STNotificationWindow *) notificationWindow {
    if (!_notificationWindow) {
        _notificationWindow = [[STNotificationWindow alloc] init];
        _notificationWindow.displayDuration = 3;
        _notificationWindow.maximumNumberOfWindows = 3;
        _notificationWindow.notificationWindowDelegate = self;
    }
    return _notificationWindow;
}

- (void) allNoticationViewDismissed {
    self.notificationWindow = nil;
}

#pragma mark - PrivateMethod

- (void) initializeCustomUserSetting {
    
    NSString * settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if (settingsBundle) {
        NSString * path = [settingsBundle stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray * preferences = [dictionary objectForKey:@"PreferenceSpecifiers"];
        NSMutableDictionary *defaultsToRegister = [NSMutableDictionary dictionaryWithCapacity:[preferences count]];
        for(NSDictionary * prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if(key) {
                [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
        BOOL voiceEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"voiceControlEnabled"] boolValue];
        if (voiceEnabled) {
            AVAudioSession * avSession = [AVAudioSession sharedInstance];
            NSError * setCategoryError;
            [avSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
            self.voiceRecognizer = [[STDWXVoiceRecognizer alloc] init];
            self.voiceRecognizer.delegate = self;
        }
        _FLEXEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FLEXEnabled"] boolValue];
    }
    
    [MobClick startWithAppkey:kSTKitDemoUmengAppKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [MobClick setAppVersion:version];
    [MobClick checkUpdate:@"新版提醒" cancelButtonTitle:@"先不管" otherButtonTitles:@"去更新"];
    
    [[STThemeManager currentTheme] setThemeValue:[UIColor colorWithRGB:0x999999] forKey:@"BookTextColor" whenContainedIn:NSClassFromString(@"STRichView")];
    UIFont * bookFont = [UIFont fontWithName:@"STHeitiSC-Light" size:21.];
    [[STThemeManager currentTheme] setThemeValue:bookFont forKey:@"BookTextFont" whenContainedIn:NSClassFromString(@"STRichView")];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setValue:bookFont forKey:NSFontAttributeName];
    [dict setValue:@(2) forKey:NSKernAttributeName];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    [dict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [[STThemeManager currentTheme] setThemeValue:dict forKey:@"BookTextAttributes" whenContainedIn:NSClassFromString(@"STRichView")];
    [[STCoreDataManager defaultDataManager] setModelName:@"STDModel"];
}

- (void) testFFT {
    NSMutableData * mixData = [NSMutableData dataWithCapacity:512];
    int  sampleRate = 512;
    const int frequencyCount = 8;
    int frequency[frequencyCount] = {1, 32, 64, 100, 110 ,128, 200, 255};
    float amplitude = 1000;
    float delta = 1.0 / sampleRate;
    for (float time = 0; time < 1; time += delta) {
        float data = 0.0;
        for (int j = 0; j < frequencyCount; j ++) {
            data += amplitude * sin(2.0 * M_PI * (float)frequency[j] * time);
        }
        /// data 区间 位 -j * amplitude - j * amplitude 映射到 -32767-32767
        SInt16 dataI = (SInt16) (data * 32767 / (frequencyCount * amplitude));
        [mixData appendBytes:&dataI length:sizeof(dataI)];
    }
    fft_state * fft = visual_fft_init();
    SInt16 pcmData[FFT_BUFFER_SIZE];
    [mixData getBytes:pcmData range:NSMakeRange(0, MIN(mixData.length, sizeof(pcmData)))];
    SInt16 result[FFT_RESULT_SIZE];
    float tmp_out[FFT_BUFFER_SIZE];
	fft_perform(pcmData,tmp_out, fft);
	for(int i = 0; i < FFT_BUFFER_SIZE; i++) {
        result[i] = (SInt16)(tmp_out[i] *  ( 2 ^ 16 ) / ( ( FFT_BUFFER_SIZE / 2 * 32768 ) ^ 2 ));
    }
    
    fft_close(fft);
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && _FLEXEnabled) {
        [[FLEXManager sharedManager] showExplorer];
    }
}

@end

NSString * const STDVoiceRecognizerNotification = @"STDVoiceRecognizerNotification";

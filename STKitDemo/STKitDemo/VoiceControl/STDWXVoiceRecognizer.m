//
//  STDWXVoiceRecognizer.m
//  STKitDemo
//
//  Created by SunJiangting on 14-7-18.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDWXVoiceRecognizer.h"
#import "WXVoiceSDK.h"


@interface STDWXVoiceRecognizer () <WXVoiceDelegate>

@property (nonatomic, weak) WXVoiceSDK * voiceSDK;

@property (nonatomic, assign) BOOL  recognizing;

@end

@implementation STDWXVoiceRecognizer

- (void) dealloc {
    self.voiceSDK.delegate = nil;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.voiceSDK = [WXVoiceSDK sharedWXVoice];
        self.voiceSDK.delegate = self;
        self.maximumMuteDuration = 0.5;
        self.voiceSDK.silTime = self.maximumMuteDuration;
        [self.voiceSDK setUserKey:@"248b63f1ceca9158ca88516bcb338e82a482ecd802cbca12"];
        
    }
    return self;
}

- (void) startListening {
    if (!self.recognizing) {
        [self.voiceSDK startOnce];
    }
    self.recognizing = YES;
}

- (void) stopListening {
    if (self.recognizing) {
         [self.voiceSDK finish];
    }
    self.recognizing = NO;
}

- (void) cancel {
    [self.voiceSDK cancel];
    self.recognizing = NO;
}

- (void) setMaximumMuteDuration:(NSTimeInterval)maximumMuteDuration {
    self.voiceSDK.silTime = maximumMuteDuration;
    [super setMaximumMuteDuration:maximumMuteDuration];
}

//识别成功，返回结果，元素类型为WXVoiceResult，现阶段数组内只有一个元素
- (void)voiceInputResultArray:(NSArray *)array {
    WXVoiceResult * result = array[0];
    if ([self.delegate respondsToSelector:@selector(voiceRecognizer:didRecognizeText:)]) {
        [self.delegate voiceRecognizer:self didRecognizeText:result.text];
    }
    self.recognizing = NO;
}

- (void)voiceInputMakeError:(NSInteger)errorCode {
    if ([self.delegate respondsToSelector:@selector(voiceRecognizer:didFailToRecognizeWithError:)]) {
        [self.delegate voiceRecognizer:self didFailToRecognizeWithError:[NSError errorWithDomain:@"com.suen.voice" code:errorCode userInfo:nil]];
    }
    self.recognizing = NO;
}//出现错误，错误码请参见官方网站

- (void)voiceInputWaitForResult {
    
}//录音完成，等待服务器返回识别结果。此时不会再接受新的语音

- (void)voiceInputDidCancel {
    
}//在手动调用的cancel后，取消完成时回调


- (void)voiceInputVolumn:(float)volumn {
    if ([self.delegate respondsToSelector:@selector(voiceRecognizer:didChangeVolumn:)]) {
        [self.delegate voiceRecognizer:self didChangeVolumn:volumn];
    }
} //音量，界限为0-30，通常音量范围在0-15之间

@end

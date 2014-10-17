//
//  STVoiceRecognizer.h
//  STKitDemo
//
//  Created by SunJiangting on 14-7-18.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
// UIGestureRecognizerState
@class STVoiceRecognizer;
@protocol STVoiceRecognizerDelegate <NSObject>

- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didRecognizeText:(NSString *) text;
- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didFailToRecognizeWithError:(NSError *) error;

@optional
- (void) voiceRecognizer:(STVoiceRecognizer *) voiceRecognizer didChangeVolumn:(CGFloat) volumn;

@end

@interface STVoiceRecognizer : NSObject

@property (nonatomic, weak) id <STVoiceRecognizerDelegate> delegate;

/// 最长静音时间，超过这个时间之后就开始识别, default 2
@property (nonatomic, assign) NSTimeInterval     maximumMuteDuration;
/// 开始录音
- (void) startListening;
/// 结束录音
- (void) stopListening;
/// 取消
- (void) cancel;

@end

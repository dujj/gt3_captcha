//
//  GT3CaptchaAsyncTask.h
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//
#import <Flutter/Flutter.h>
#import <GT3Captcha/GT3Captcha.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GT3CaptchaAsyncTask : NSObject<GT3AsyncTaskProtocol>

- (instancetype)initWithFlutterMethodChannel:(FlutterMethodChannel *)channel;


@end

NS_ASSUME_NONNULL_END

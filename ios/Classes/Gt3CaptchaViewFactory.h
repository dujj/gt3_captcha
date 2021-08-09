//
//  Gt3CaptchaViewFactory.h
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Gt3CaptchaViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END

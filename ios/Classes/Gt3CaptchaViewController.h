//
//  Gt3CaptchaViewController.h
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//
#import <Flutter/Flutter.h>
#import <GT3Captcha/GT3Captcha.h>
#import <Foundation/Foundation.h>
#import "GT3CaptchaAsyncTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface Gt3CaptchaViewController : NSObject <FlutterPlatformView, GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END

//
//  Gt3CaptchaViewFactory.m
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//
#import "Gt3CaptchaViewController.h"
#import "Gt3CaptchaViewFactory.h"

@implementation Gt3CaptchaViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[Gt3CaptchaViewController alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

@end

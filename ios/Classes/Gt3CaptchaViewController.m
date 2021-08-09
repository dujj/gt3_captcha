//
//  Gt3CaptchaViewController.m
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//

#import "Gt3CaptchaViewController.h"
#import "Gt3CaptchaView.h"



@implementation Gt3CaptchaViewController {
    Gt3CaptchaView *_view;
    int64_t _viewId;
    FlutterMethodChannel *_channel;
    GT3CaptchaAsyncTask *_asyncTask;
    GT3CaptchaManager *_manager;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      _viewId = viewId;

      NSString* channelName = [NSString stringWithFormat:@"plugins.flutter.io/gt3_captcha_view_%lld", viewId];
      _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
      

      
      _asyncTask = [[GT3CaptchaAsyncTask alloc] initWithFlutterMethodChannel:_channel];
      
      _manager = [[GT3CaptchaManager alloc] initWithAPI1:nil API2:nil timeout:15.0];
      _manager.delegate = self;
      _manager.viewDelegate = self;
      [_manager disableBackgroundUserInteraction:YES];
      _manager.maskColor = [UIColor colorWithWhite:0 alpha:0.6];
      [_manager useGTViewWithCornerRadius:12.0];
      
      [_manager registerCaptchaWithCustomAsyncTask:_asyncTask completion:^{
                
      }];
      
      _view = [[Gt3CaptchaView alloc] initWithFrame:frame];

      __weak __typeof__(self) weakSelf = self;
      [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [weakSelf onMethodCall:call result:result];
      }];

  }
  return self;
}

- (UIView*)view {
  return _view;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([[call method] isEqualToString:@"start"]) {
      [_view showAnimate];
      [_manager startGTCaptchaWithAnimated:YES];
      result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)gtCaptchaWillShowGTView:(GT3CaptchaManager *)manager {
    [_view hiddenAnimate];
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    
}

@end


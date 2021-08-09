#import "Gt3CaptchaPlugin.h"
#import "Gt3CaptchaViewFactory.h"

@implementation Gt3CaptchaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    Gt3CaptchaViewFactory *gt3CaptchaViewFactory = [[Gt3CaptchaViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:gt3CaptchaViewFactory withId:@"plugins.flutter.io/gt3_captcha_view"];
}

@end

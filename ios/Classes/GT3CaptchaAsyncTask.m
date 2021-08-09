//
//  GT3CaptchaAsyncTask.m
//  gt3_captcha
//
//  Created by dujianjie on 2021/7/27.
//

#import "GT3CaptchaAsyncTask.h"

@implementation GT3CaptchaAsyncTask {
    FlutterMethodChannel *_channel;
}

- (instancetype)initWithFlutterMethodChannel:(FlutterMethodChannel *)channel {
    if (self = [super init]) {
        _channel = channel;
    }
    return self;
}

- (void)cancel {
}

- (void)executeRegisterTaskWithCompletion:(nonnull void (^)(GT3RegisterParameter * _Nullable, GT3Error * _Nullable))completion {
    [_channel invokeMethod:@"onRegister" arguments:nil result:^(id  _Nullable result) {
        if ([result isKindOfClass:NSString.class]) {
            NSData *data = [((NSString *)result) dataUsingEncoding:(NSUTF8StringEncoding)];
            id mData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([mData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *mDict  = (NSDictionary *)mData;
                GT3RegisterParameter *registerParameter = [[GT3RegisterParameter alloc] init];
                registerParameter.gt = mDict[@"gt"];
                registerParameter.challenge = mDict[@"challenge"];
                BOOL success = [mDict[@"success"] boolValue];
                if (success) {
                    registerParameter.success = [NSNumber numberWithInteger:1];
                } else {
                    registerParameter.success = [NSNumber numberWithInteger:0];
                }
                completion(registerParameter, nil);
                return;
            }
        }
        completion(nil, [GT3Error errorWithDomainType:(GT3ErrorTypeNetWorking) code:2020 userInfo:nil withGTDesciption:@"network error"]);
    }];
}

- (void)executeValidationTaskWithValidateParam:(nonnull GT3ValidationParam *)param completion:(nonnull void (^)(BOOL, GT3Error * _Nullable))completion {
    NSData *data = [NSJSONSerialization dataWithJSONObject:param.result options:0 error:nil];
    NSString *mParam =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [_channel invokeMethod:@"onValidation" arguments:mParam result:^(id  _Nullable result) {
        if ([result isKindOfClass:NSNumber.class]) {
            BOOL success = ((NSNumber *)result).boolValue;
            if (success) {
                completion(YES, nil);
            }
            return;
        }
        completion(NO, [GT3Error errorWithDomainType:(GT3ErrorTypeNetWorking) code:2020 userInfo:nil withGTDesciption:@"network error"]);
    }];
}

@end

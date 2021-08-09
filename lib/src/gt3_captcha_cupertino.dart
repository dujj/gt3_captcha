import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../platform_interface.dart';
import 'gt3_captcha_method_channel.dart';

class CupertinoGt3CaptchaView implements Gt3CaptchaViewPlatform {
  @override
  Widget build({
    required BuildContext context,
    required Gt3CaptchaViewPlatformCallbacksHandler
        gt3CaptchaViewPlatformCallbacksHandler,
    Gt3CaptchaViewPlatformCreatedCallback? onGt3CaptchaViewPlatformCreated,
  }) {
    return UiKitView(
      viewType: 'plugins.flutter.io/gt3_captcha_view',
      onPlatformViewCreated: (int id) {
        if (onGt3CaptchaViewPlatformCreated == null) {
          return;
        }
        onGt3CaptchaViewPlatformCreated(MethodChannelGt3CaptchaViewPlatform(
            id, gt3CaptchaViewPlatformCallbacksHandler));
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

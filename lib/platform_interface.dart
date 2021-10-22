import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class Gt3CaptchaViewPlatformCallbacksHandler {
  // {"success":1,"challenge":"06fbb267def3c3c9530d62aa2d56d018","gt":"019924a82c70bb123aae90d483087f94","new_captcha":true}
  Future<String?> onRegister();
  Future<bool?> onValidation(String params);

  Future<Null> onGtViewShow();
  Future<Null> onCancel();
  Future<Null> onError();
}

abstract class Gt3CaptchaViewPlatformController {
  Gt3CaptchaViewPlatformController(
      Gt3CaptchaViewPlatformCallbacksHandler handler);

  Future<Null> start() {
    throw UnimplementedError(
        "gt3 start is not implemented on the current platform");
  }
}

typedef Gt3CaptchaViewPlatformCreatedCallback = void Function(
    Gt3CaptchaViewPlatformController gt3CaptchaViewPlatformController);

typedef Gt3CaptchaViewPlatformRegisterCallback = Future<String?> Function();
typedef Gt3CaptchaViewPlatformValidationCallback = Future<bool?> Function(
    String);
typedef Gt3CaptchaViewPlatformNullCallback = Future<Null> Function();

abstract class Gt3CaptchaViewPlatform {
  Widget build({
    required BuildContext context,
    required Gt3CaptchaViewPlatformCallbacksHandler
        gt3CaptchaViewPlatformCallbacksHandler,
    Gt3CaptchaViewPlatformCreatedCallback? onGt3CaptchaViewPlatformCreated,
  });
}

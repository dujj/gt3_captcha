import 'dart:async';

import 'package:flutter/services.dart';

import '../platform_interface.dart';

class MethodChannelGt3CaptchaViewPlatform
    implements Gt3CaptchaViewPlatformController {
  MethodChannelGt3CaptchaViewPlatform(int id, this._platformCallbacksHandler)
      : _channel = MethodChannel('plugins.flutter.io/gt3_captcha_view_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final Gt3CaptchaViewPlatformCallbacksHandler _platformCallbacksHandler;

  final MethodChannel _channel;

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onRegister':
        return await _platformCallbacksHandler.onRegister();
      case 'onValidation':
        var params = call.arguments as String;
        return await _platformCallbacksHandler.onValidation(params);
    }

    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  @override
  Future<Null> start() => _channel.invokeMethod("start");
}

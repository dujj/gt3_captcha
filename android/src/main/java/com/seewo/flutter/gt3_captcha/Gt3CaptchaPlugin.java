package com.seewo.flutter.gt3_captcha;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;

/** Gt3CaptchaPlugin */
public class Gt3CaptchaPlugin implements FlutterPlugin {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory(
                    "plugins.flutter.io/gt3_captcha_view",
                    new Gt3CaptchaViewFactory(messenger, /*containerView=*/ null));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }
}

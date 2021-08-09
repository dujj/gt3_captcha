import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'platform_interface.dart';
import 'src/gt3_captcha_android.dart';
import 'src/gt3_captcha_cupertino.dart';
import 'src/gt3_captcha_method_channel.dart';

typedef void Gt3CaptchaViewCreatedCallback(Gt3CaptchaViewController controller);

class SurfaceAndroidGt3CaptchaView extends AndroidGt3CaptchaView {
  @override
  Widget build({
    required BuildContext context,
    Gt3CaptchaViewPlatformCreatedCallback? onGt3CaptchaViewPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    required Gt3CaptchaViewPlatformCallbacksHandler
        gt3CaptchaViewPlatformCallbacksHandler,
  }) {
    assert(Platform.isAndroid);
    return PlatformViewLink(
      viewType: 'plugins.flutter.io/gt3_captcha_view',
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: 'plugins.flutter.io/gt3_captcha_view',
          // WebView content is not affected by the Android view's layout direction,
          // we explicitly set it here so that the widget doesn't require an ambient
          // directionality.
          layoutDirection: TextDirection.rtl,
          creationParamsCodec: const StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((int id) {
            if (onGt3CaptchaViewPlatformCreated == null) {
              return;
            }
            onGt3CaptchaViewPlatformCreated(
              MethodChannelGt3CaptchaViewPlatform(
                  id, gt3CaptchaViewPlatformCallbacksHandler),
            );
          })
          ..create();
      },
    );
  }
}

typedef Gt3CaptchaErrorCallback = void Function(String, String);

class Gt3CaptchaView extends StatefulWidget {
  const Gt3CaptchaView({
    Key? key,
    required this.onRegister,
    required this.onValidation,
    this.onGt3CaptchaViewCreated,
  }) : super(key: key);

  static Gt3CaptchaViewPlatform? _platform;

  static set platform(Gt3CaptchaViewPlatform? platform) {
    _platform = platform;
  }

  static Gt3CaptchaViewPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidGt3CaptchaView();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoGt3CaptchaView();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default webview implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform!;
  }

  final Gt3CaptchaViewCreatedCallback? onGt3CaptchaViewCreated;

  final Gt3CaptchaViewPlatformRegisterCallback onRegister;

  final Gt3CaptchaViewPlatformValidationCallback onValidation;

  @override
  State<StatefulWidget> createState() => _Gt3CaptchaViewState();
}

class _Gt3CaptchaViewState extends State<Gt3CaptchaView> {
  final Completer<Gt3CaptchaViewController> _controller =
      Completer<Gt3CaptchaViewController>();

  late _PlatformCallbacksHandler _platformCallbacksHandler;

  @override
  Widget build(BuildContext context) {
    return Gt3CaptchaView.platform.build(
      context: context,
      onGt3CaptchaViewPlatformCreated: _onGt3CaptchaViewPlatformCreated,
      gt3CaptchaViewPlatformCallbacksHandler: _platformCallbacksHandler,
    );
  }

  @override
  void initState() {
    super.initState();
    _platformCallbacksHandler = _PlatformCallbacksHandler(widget);
  }

  @override
  void didUpdateWidget(Gt3CaptchaView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.future.then((Gt3CaptchaViewController controller) {
      _platformCallbacksHandler._widget = widget;
    });
  }

  void _onGt3CaptchaViewPlatformCreated(
      Gt3CaptchaViewPlatformController gt3CaptchaViewPlatform) {
    final Gt3CaptchaViewController controller =
        Gt3CaptchaViewController._(gt3CaptchaViewPlatform);
    _controller.complete(controller);
    if (widget.onGt3CaptchaViewCreated != null) {
      widget.onGt3CaptchaViewCreated!(controller);
    }
  }
}

class _PlatformCallbacksHandler
    implements Gt3CaptchaViewPlatformCallbacksHandler {
  _PlatformCallbacksHandler(this._widget);

  Gt3CaptchaView _widget;

  Future<String?> onRegister() async {
    return await _widget.onRegister();
  }

  Future<bool?> onValidation(String params) async {
    return await _widget.onValidation(params);
  }
}

class Gt3CaptchaViewController {
  Gt3CaptchaViewController._(
    this._gt3CaptchaViewPlatformController,
  );

  final Gt3CaptchaViewPlatformController _gt3CaptchaViewPlatformController;

  Future<Null> start() {
    return _gt3CaptchaViewPlatformController.start();
  }
}

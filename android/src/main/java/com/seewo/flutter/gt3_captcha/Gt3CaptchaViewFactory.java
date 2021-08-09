package com.seewo.flutter.gt3_captcha;
import android.content.Context;
import android.view.View;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

public final class Gt3CaptchaViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final View containerView;

    Gt3CaptchaViewFactory(BinaryMessenger messenger, View containerView) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.containerView = containerView;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        MethodChannel methodChannel = new MethodChannel(messenger, "plugins.flutter.io/gt3_captcha_view_" + id);
        return new Gt3CaptchaView(context, methodChannel, params, containerView);
    }
}

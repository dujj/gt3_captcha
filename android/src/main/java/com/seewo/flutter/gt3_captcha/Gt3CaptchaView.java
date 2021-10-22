package com.seewo.flutter.gt3_captcha;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.geetest.sdk.GT3ErrorBean;
import com.geetest.sdk.GT3GeetestUtils;
import com.geetest.sdk.GT3ConfigBean;
import com.geetest.sdk.GT3Listener;

import java.util.Map;
import java.util.logging.Logger;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class Gt3CaptchaView implements PlatformView, MethodChannel.MethodCallHandler {

    private final View gt3CaptchaView;
    private final MethodChannel methodChannel;

    private final GT3GeetestUtils gt3GeetestUtils;
    private final GT3ConfigBean gt3ConfigBean;

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    @SuppressWarnings("unchecked")
    Gt3CaptchaView(
            final Context context,
            MethodChannel methodChannel,
            Map<String, Object> params,
            View containerView) {


        this.methodChannel = methodChannel;
        this.methodChannel.setMethodCallHandler(this);

        gt3GeetestUtils = new GT3GeetestUtils(context);
        gt3ConfigBean = new GT3ConfigBean();
        gt3ConfigBean.setCorners(12);
        gt3ConfigBean.setPattern(1);
        gt3ConfigBean.setCanceledOnTouchOutside(false);
        gt3ConfigBean.setTimeout(15000);
        gt3ConfigBean.setWebviewTimeout(15000);
        gt3ConfigBean.setListener(new CustomListener());
        gt3GeetestUtils.init(gt3ConfigBean);

        gt3CaptchaView = new CustomView(context);
    }

    @Override
    public View getView() {
        return gt3CaptchaView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "start":
                gt3GeetestUtils.startCustomFlow();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
        if (gt3GeetestUtils != null) {
            gt3GeetestUtils.destory();
        }
    }

    class CustomListener extends GT3Listener {


        @Override
        public void onReceiveCaptchaCode(int i) {
            Log.i("flutter", "onReceiveCaptchaCode");
        }

        @Override
        public void onDialogReady(String s) {
            Log.i("flutter", "onDialogReady");
        }

        @Override
        public void onDialogResult(String result) {
            Log.i("flutter", "onDialogResult");
            methodChannel.invokeMethod("onValidation", result, new MethodChannel.Result() {
                @Override
                public void success(@Nullable @org.jetbrains.annotations.Nullable Object result) {
                    if (result != null) {
                        Boolean success = new Boolean(result.toString());
                        if (success) {
                            gt3GeetestUtils.showSuccessDialog();
                        } else {
                            gt3GeetestUtils.showFailedDialog();
                        }
                    } else {
                        gt3GeetestUtils.showFailedDialog();
                    }

                }

                @Override
                public void error(String errorCode, @Nullable @org.jetbrains.annotations.Nullable String errorMessage, @Nullable @org.jetbrains.annotations.Nullable Object errorDetails) {
                    gt3GeetestUtils.showFailedDialog();
                }

                @Override
                public void notImplemented() {
                    gt3GeetestUtils.showFailedDialog();
                }
            });
        }

        @Override
        public void onStatistics(String s) {
            Log.i("flutter", "onStatistics");
        }

        @Override
        public void onClosed(int i) {
            Log.i("flutter", "onClosed");
            methodChannel.invokeMethod("onCancel", null, null);
        }

        @Override
        public void onSuccess(String s) {
            Log.i("flutter", "onSuccess");
        }

        @Override
        public void onFailed(GT3ErrorBean gt3ErrorBean) {
            Log.i("flutter", "onFailed");
            methodChannel.invokeMethod("onError", null, null);
        }

        @Override
        public void onButtonClick() {
            Log.i("flutter", "onButtonClick");
            methodChannel.invokeMethod("onGtViewShow", null, null);
            methodChannel.invokeMethod("onRegister", null, new MethodChannel.Result() {
                @Override
                public void success(@Nullable @org.jetbrains.annotations.Nullable Object result) {
                    if (result != null) {
                        try {
                            JSONObject data = new JSONObject(result.toString());
                            Boolean success = data.optBoolean("success");
                            if (success) {
                                data.put("success", 1);
                            } else {
                                data.put("success", 0);
                            }
                            data.put("new_captcha", true);
                            gt3ConfigBean.setApi1Json(data);
                        } catch (JSONException e) {
                            e.printStackTrace();
                            gt3ConfigBean.setApi1Json(null);
                        }
                    } else {
                        gt3ConfigBean.setApi1Json(null);
                    }
                    // 继续验证
                    gt3GeetestUtils.getGeetest();
                }

                @Override
                public void error(String errorCode, @Nullable @org.jetbrains.annotations.Nullable String errorMessage, @Nullable @org.jetbrains.annotations.Nullable Object errorDetails) {
                    gt3ConfigBean.setApi1Json(null);
                    gt3GeetestUtils.getGeetest();
                }

                @Override
                public void notImplemented() {
                    gt3ConfigBean.setApi1Json(null);
                    gt3GeetestUtils.getGeetest();
                }
            });
        }
    }

    class CustomView extends ViewGroup {

        private final View coverView;

        public CustomView(Context context) {
            super(context);
            this.setBackgroundColor(0x00000000);
            coverView = new View(context);
            coverView.setBackgroundColor(0x00000000);
            this.addView(coverView);
        }

        @Override
        protected void onLayout(boolean changed, int l, int t, int r, int b) {
            coverView.layout(l, t, r, b);
        }
    }
}




import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gt3_captcha/gt3_captcha.dart';

late final Dio _dio = Dio()
  ..options.connectTimeout = 15000
  ..options.sendTimeout = 15000
  ..options.receiveTimeout = 15000;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<Gt3CaptchaViewController> _controller =
      Completer<Gt3CaptchaViewController>();

  bool isShowCaptch = false;
  String? va;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid)
      Gt3CaptchaView.platform = SurfaceAndroidGt3CaptchaView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Column(
              children: [
                Text(va ?? ""),
                TextButton(
                    onPressed: () {
                      setState(() {
                        isShowCaptch = true;
                      });
                    },
                    child: Text("click to get Code"))
              ],
            ),
          ),
          Visibility(
            visible: isShowCaptch,
            child: Gt3CaptchaView(
              onRegister: () async {
                return await _onRegister();
              },
              onValidation: (params) async {
                String? result = await _onValidation(params);
                setState(() {
                  va = result;
                  isShowCaptch = false;
                });
                return (result != null) ? true : false;
              },
              onGt3CaptchaViewCreated: (controller) {
                controller.start();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _onRegister() async {
    final url = "https://*******/register";
    var res = await _dio.post(url);
    var data = res.data;
    print(data);
    if (data != null) {
      int? code = data['code'] as int?;
      var result = data['data'];
      if (code == 0 && result != null) {
        return JsonEncoder().convert(result);
      }
    }
    return null;
  }

  Future<String?> _onValidation(String params) async {
    final url = "https://*******/validate";
    var mParams = JsonDecoder().convert(params);
    var res = await _dio.post(url, data: mParams);
    var data = res.data;
    print(data);
    if (data != null) {
      int? code = data['code'] as int?;
      Map? result = data['data'] as Map<String, dynamic>?;
      if (code == 0 && result != null) {
        String key = result["validate"] as String? ?? "";
        String captcha = result["challenge"] as String? ?? "";
        if (key.isNotEmpty && captcha.isNotEmpty) {
          return "key:$key captcha:$captcha";
        }
      }
    }
    return null;
  }
}

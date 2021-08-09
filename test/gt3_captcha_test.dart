import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt3_captcha/gt3_captcha.dart';

void main() {
  const MethodChannel channel = MethodChannel('gt3_captcha');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Gt3Captcha.platformVersion, '42');
  });
}

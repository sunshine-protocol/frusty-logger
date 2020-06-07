import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frusty_logger/frusty_logger.dart';

void main() {
  const MethodChannel channel = MethodChannel('frusty_logger');

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
    expect(await FrustyLogger.platformVersion, '42');
  });
}

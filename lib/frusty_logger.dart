import 'dart:async';

import 'package:flutter/services.dart';

class FrustyLogger {
  static const MethodChannel _channel =
      const MethodChannel('frusty_logger');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

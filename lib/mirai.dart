import 'dart:async';

import 'package:flutter/services.dart';

class Mirai {
  static const MethodChannel _channel = const MethodChannel('chaquopy');

  /// result['success']
  /// result['error']
  static void startNode() async {
    await _channel.invokeMethod('runPythonScript');
  }

  static Future<bool> isRunning() async {
    return await _channel.invokeMethod('isRunning');
  }

  static void stopNode() async {
    await _channel.invokeMethod('stopNode');
  }
}
import 'dart:async';

import 'package:flutter/services.dart';

class Mirai {
  static const MethodChannel _channel = const MethodChannel('chaquopy');

  /// result['success']
  /// result['error']
  static void startNode() async {
    await _channel.invokeMethod('runPythonScript');
  }

  static bool isRunning() {
    return _channel.invokeMethod('isRunning') as bool;
  }

  static void stopNode() async {
    await _channel.invokeMethod('stopNode');
  }
}
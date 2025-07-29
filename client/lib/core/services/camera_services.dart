import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('com.smartar/camera_intrinsics');

Future<Map<String, dynamic>> getCameraIntrinsics() async {
  final result = await _channel.invokeMethod('getIntrinsics');
  return Map<String, dynamic>.from(result);
}

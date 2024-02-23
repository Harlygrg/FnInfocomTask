import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('bluetooth_channel');

class BluetoothChannel {
  static Future<void> enableBluetooth() async {
    try {
      await _channel.invokeMethod('enableBluetooth');
    } on PlatformException catch (e) {
      print("Failed to enable Bluetooth: '${e.message}'.");
    }
  }
}

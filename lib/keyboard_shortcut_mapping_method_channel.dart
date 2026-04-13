import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'keyboard_shortcut_mapping_platform_interface.dart';

/// An implementation of [KeyboardShortcutMappingPlatform] that uses method channels.
class MethodChannelKeyboardShortcutMapping extends KeyboardShortcutMappingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('keyboard_shortcut_mapping');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

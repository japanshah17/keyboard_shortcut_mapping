import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping.dart';
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping_platform_interface.dart';
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKeyboardShortcutMappingPlatform
    with MockPlatformInterfaceMixin
    implements KeyboardShortcutMappingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KeyboardShortcutMappingPlatform initialPlatform = KeyboardShortcutMappingPlatform.instance;

  test('$MethodChannelKeyboardShortcutMapping is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKeyboardShortcutMapping>());
  });

  test('getPlatformVersion', () async {
    KeyboardShortcutMapping keyboardShortcutMappingPlugin = KeyboardShortcutMapping();
    MockKeyboardShortcutMappingPlatform fakePlatform = MockKeyboardShortcutMappingPlatform();
    KeyboardShortcutMappingPlatform.instance = fakePlatform;

    expect(await keyboardShortcutMappingPlugin.getPlatformVersion(), '42');
  });
}

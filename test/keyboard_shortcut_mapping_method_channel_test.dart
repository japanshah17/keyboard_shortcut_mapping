import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KeyboardShortcutMapping', () {
    setUp(() async {
      await KeyboardShortcutMapping.unregisterAll();
    });

    tearDown(() async {
      await KeyboardShortcutMapping.unregisterAll();
    });

    test('register and retrieve shortcuts', () async {
      await KeyboardShortcutMapping.register(
        modifiers: ['cmd'],
        key: 's',
        callback: () async {},
        id: 'test_save',
      );

      final shortcuts = KeyboardShortcutMapping.getShortcuts();
      expect(shortcuts.containsKey('test_save'), true);
      expect(shortcuts['test_save']?.key, 's');
      expect(shortcuts['test_save']?.modifiers, ['cmd']);
    });

    test('unregister shortcut', () async {
      await KeyboardShortcutMapping.register(
        modifiers: ['cmd'],
        key: 's',
        callback: () async {},
        id: 'test_save',
      );

      await KeyboardShortcutMapping.unregister('test_save');
      final shortcuts = KeyboardShortcutMapping.getShortcuts();
      expect(shortcuts.containsKey('test_save'), false);
    });

    test('handle key event executes callback', () async {
      bool callbackExecuted = false;

      await KeyboardShortcutMapping.register(
        modifiers: ['cmd'],
        key: 's',
        callback: () async {
          callbackExecuted = true;
        },
        id: 'test_save',
      );

      await KeyboardShortcutMapping.handleKeyEvent(['cmd'], 's');
      expect(callbackExecuted, true);
    });

    test('unregisterAll clears all shortcuts', () async {
      await KeyboardShortcutMapping.register(
        modifiers: ['cmd'],
        key: 's',
        callback: () async {},
        id: 'test_save',
      );

      await KeyboardShortcutMapping.register(
        modifiers: ['cmd'],
        key: 'q',
        callback: () async {},
        id: 'test_quit',
      );

      await KeyboardShortcutMapping.unregisterAll();
      final shortcuts = KeyboardShortcutMapping.getShortcuts();
      expect(shortcuts.isEmpty, true);
    });
  });
}

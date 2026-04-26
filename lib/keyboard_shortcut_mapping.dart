import 'keyboard_shortcut_mapping_platform_interface.dart';

/// Typedef for keyboard shortcut callback functions.
typedef ShortcutCallback = Future<void> Function();

/// Represents a keyboard shortcut with key combination and callback.
class KeyboardShortcut {
  final List<String> modifiers;
  final String key;
  final ShortcutCallback callback;
  final String id;

  KeyboardShortcut({
    required this.modifiers,
    required this.key,
    required this.callback,
    required this.id,
  });
}

/// In-memory keyboard shortcut manager.
///
/// Manages shortcuts for the current session. Persistence (e.g. SharedPreferences)
/// is intentionally left to the caller — load saved shortcuts before calling
/// [register], and save the result of [getShortcuts] after any mutation.
///
/// Usage:
/// ```dart
/// // Register a shortcut
/// KeyboardShortcutMapping.register(
///   modifiers: ['cmd'],
///   key: 's',
///   callback: () async { print('Save!'); },
///   id: 'save',
/// );
///
/// // Restore a callback for a previously persisted shortcut
/// KeyboardShortcutMapping.registerCallback(
///   id: 'save',
///   callback: () async { print('Save!'); },
/// );
///
/// // Handle a key event (call from your KeyboardListener)
/// await KeyboardShortcutMapping.handleKeyEvent(['cmd'], 's');
/// ```
class KeyboardShortcutMapping {
  static final Map<String, ShortcutCallback> _callbacks = {};
  static final Map<String, Map<String, dynamic>> _shortcutData = {};

  /// Get the platform version.
  Future<String?> getPlatformVersion() {
    return KeyboardShortcutMappingPlatform.instance.getPlatformVersion();
  }

  /// Register a shortcut in memory.
  static void register({
    required List<String> modifiers,
    required String key,
    required ShortcutCallback callback,
    required String id,
  }) {
    _callbacks[id] = callback;
    _shortcutData[id] = {'modifiers': modifiers, 'key': key};
  }

  /// Register only the callback for an already-loaded shortcut.
  /// Use this when restoring persisted shortcuts at startup.
  static void registerCallback({
    required String id,
    required ShortcutCallback callback,
  }) {
    _callbacks[id] = callback;
  }

  /// Remove a shortcut from memory.
  static void unregister(String id) {
    _callbacks.remove(id);
    _shortcutData.remove(id);
  }

  /// Remove all shortcuts from memory.
  static void unregisterAll() {
    _callbacks.clear();
    _shortcutData.clear();
  }

  /// Returns all currently registered shortcuts.
  static Map<String, KeyboardShortcut> getShortcuts() {
    return {
      for (final entry in _shortcutData.entries)
        entry.key: KeyboardShortcut(
          modifiers: List<String>.from(entry.value['modifiers'] as List),
          key: entry.value['key'] as String,
          callback: _callbacks[entry.key] ?? (() async {}),
          id: entry.key,
        ),
    };
  }

  /// Check pressed keys against registered shortcuts and fire a match.
  static Future<void> handleKeyEvent(
    List<String> pressedModifiers,
    String pressedKey,
  ) async {
    for (final entry in _shortcutData.entries) {
      final id = entry.key;
      final regMods = List<String>.from(entry.value['modifiers'] as List);
      final regKey = entry.value['key'] as String;

      bool modMatch = regMods.length == pressedModifiers.length;
      if (modMatch) {
        for (int i = 0; i < regMods.length; i++) {
          if (regMods[i] != pressedModifiers[i]) {
            modMatch = false;
            break;
          }
        }
      }

      if (modMatch && regKey.toLowerCase() == pressedKey.toLowerCase()) {
        await _callbacks[id]?.call();
        break;
      }
    }
  }

  /// Clear all in-memory shortcuts.
  static void dispose() {
    unregisterAll();
  }
}

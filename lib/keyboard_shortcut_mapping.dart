import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Typedef for keyboard shortcut callback functions.
/// These are async functions that execute when a shortcut is triggered.
typedef ShortcutCallback = Future<void> Function();

/// Represents a keyboard shortcut with key combination and callback.
///
/// A shortcut consists of:
/// - [modifiers]: List of modifier keys (cmd, shift, alt, ctrl)
/// - [key]: The main key to trigger the shortcut (a-z, 0-9, F1-F12, etc.)
/// - [callback]: Function to execute when shortcut is triggered
/// - [id]: Unique identifier for this shortcut
class KeyboardShortcut {
  /// The modifier keys (cmd, shift, alt, ctrl)
  final List<String> modifiers;

  /// The key code (letter, number, function key, etc.)
  final String key;

  /// The callback function to execute when shortcut is triggered
  final ShortcutCallback callback;

  /// Unique identifier for this shortcut
  final String id;

  KeyboardShortcut({
    required this.modifiers,
    required this.key,
    required this.callback,
    required this.id,
  });
}

/// Pure Flutter implementation for managing keyboard shortcuts with PERSISTENCE.
///
/// This class manages all keyboard shortcuts for the application.
/// Shortcuts work when the app window has focus using Flutter's KeyboardListener.
///
/// **PERSISTENCE MODEL:**
/// - Shortcut **configuration** (modifiers, keys, IDs) is saved to SharedPreferences
/// - **Callbacks** cannot be serialized, so they must be re-registered after each app restart
///
/// **How to use persistence:**
/// 1. Call `initialize()` on app startup to load saved shortcuts
/// 2. Call `getShortcuts()` to get all saved shortcuts
/// 3. Call `registerCallback()` to restore callbacks for each saved shortcut
///
/// Usage:
/// ```dart
/// // On app startup
/// await KeyboardShortcutMapping.initialize();
///
/// // Restore callbacks for persisted shortcuts
/// final shortcuts = KeyboardShortcutMapping.getShortcuts();
/// for (final entry in shortcuts.entries) {
///   await KeyboardShortcutMapping.registerCallback(
///     id: entry.key,
///     callback: myActionFunction, // Your callback function
///   );
/// }
///
/// // Register new shortcuts (auto-saved to SharedPreferences)
/// await KeyboardShortcutMapping.register(
///   modifiers: ['cmd'],
///   key: 's',
///   callback: () async { print('Save!'); },
///   id: 'save',
/// );
///
/// // Cleanup when done
/// await KeyboardShortcutMapping.dispose();
/// ```
class KeyboardShortcutMapping {
  /// Storage for shortcut callbacks
  static final Map<String, ShortcutCallback> _callbacks = {};

  /// Storage for registered shortcuts (persisted to SharedPreferences)
  static final Map<String, Map<String, dynamic>> _shortcutData = {};

  /// SharedPreferences instance for persistence
  static SharedPreferences? _prefs;

  /// Storage key for shortcuts in SharedPreferences
  static const String _storageKey = 'keyboard_shortcuts';

  /// Register a keyboard shortcut.
  /// Shortcut data is automatically saved to SharedPreferences.
  static Future<void> register({
    required List<String> modifiers,
    required String key,
    required ShortcutCallback callback,
    required String id,
  }) async {
    try {
      _callbacks[id] = callback;
      _shortcutData[id] = {'modifiers': modifiers, 'key': key};

      // 💾 Save to SharedPreferences for persistence
      await _saveToStorage();
    } catch (e) {
      debugPrint('❌ Error registering: $e');
    }
  }

  /// Unregister a specific shortcut. Removes from SharedPreferences.
  static Future<void> unregister(String id) async {
    try {
      _callbacks.remove(id);
      _shortcutData.remove(id);

      // 💾 Save changes to SharedPreferences
      await _saveToStorage();
    } catch (e) {
      debugPrint('❌ Error unregistering: $e');
    }
  }

  /// Unregister all shortcuts at once.
  static Future<void> unregisterAll() async {
    try {
      _callbacks.clear();
      _shortcutData.clear();

      // 💾 Clear storage
      await _saveToStorage();
    } catch (e) {
      debugPrint('❌ Error clearing: $e');
    }
  }

  /// Get all registered shortcuts
  static Map<String, KeyboardShortcut> getShortcuts() {
    final result = <String, KeyboardShortcut>{};
    for (final entry in _shortcutData.entries) {
      result[entry.key] = KeyboardShortcut(
        modifiers: List<String>.from(entry.value['modifiers'] as List),
        key: entry.value['key'] as String,
        callback: _callbacks[entry.key] ?? (() async {}),
        id: entry.key,
      );
    }
    return result;
  }

  /// Check if a key matches a shortcut and execute it
  static Future<void> handleKeyEvent(
    List<String> pressedModifiers,
    String pressedKey,
  ) async {
    for (final entry in _shortcutData.entries) {
      final id = entry.key;
      final data = entry.value;
      final regMods = List<String>.from(data['modifiers'] as List);
      final regKey = data['key'] as String;

      // Element-by-element comparison
      bool modMatch = regMods.length == pressedModifiers.length;
      if (modMatch) {
        for (int i = 0; i < regMods.length; i++) {
          if (regMods[i] != pressedModifiers[i]) {
            modMatch = false;
            break;
          }
        }
      }

      final keyMatch = regKey.toLowerCase() == pressedKey.toLowerCase();

      if (modMatch && keyMatch) {
        await _callbacks[id]?.call();
        break;
      }
    }
  }

  /// Save shortcuts to SharedPreferences
  static Future<void> _saveToStorage() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString(_storageKey, jsonEncode(_shortcutData));
    } catch (e) {
      debugPrint('❌ Error saving: $e');
    }
  }

  /// Load shortcuts from SharedPreferences
  static Future<void> _loadFromStorage() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      final stored = _prefs!.getString(_storageKey);
      if (stored != null) {
        final data = jsonDecode(stored) as Map<String, dynamic>;
        _shortcutData.clear();
        _shortcutData.addAll(data.cast<String, Map<String, dynamic>>());
      }
    } catch (e) {
      debugPrint('❌ Error loading: $e');
    }
  }

  /// Register a callback for a persisted shortcut.
  /// Use this after initialize() to restore callbacks for saved shortcuts.
  ///
  /// Example:
  /// ```dart
  /// await KeyboardShortcutMapping.initialize();
  /// await KeyboardShortcutMapping.registerCallback(
  ///   id: 'save',
  ///   callback: () async { print('Saving...'); },
  /// );
  /// ```
  static Future<void> registerCallback({
    required String id,
    required ShortcutCallback callback,
  }) async {
    _callbacks[id] = callback;
  }

  /// Initialize - loads saved shortcuts from storage
  static Future<void> initialize() async {
    await _loadFromStorage();
  }

  /// Dispose - cleanup
  static Future<void> dispose() async {
    await unregisterAll();
    debugPrint('✅ Shortcuts disposed');
  }
}

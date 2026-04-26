# Keyboard Shortcut Mapping

A Flutter plugin for managing keyboard shortcuts on desktop (macOS, Windows, Linux). Register shortcuts with modifier keys and callback functions. Persistence is intentionally left to the caller — use any storage backend you prefer.

## Features

- Register keyboard shortcuts with modifier keys (Cmd, Shift, Alt, Ctrl)
- Support for letter keys (a-z), numbers (0-9), and function keys (F1-F12)
- Manage shortcuts dynamically — add or remove at runtime
- Callback-based execution — fire any async function when a shortcut is pressed

## Platform Support

| Platform | Support |
|----------|---------|
| macOS    | ✅ |
| Windows  | ✅ |
| Linux    | ✅ |

## Installation

```yaml
dependencies:
  keyboard_shortcut_mapping: ^1.0.0
```

```bash
flutter pub get
```

## Usage

### Register a shortcut

```dart
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping.dart';

// Cmd+S
KeyboardShortcutMapping.register(
  modifiers: ['cmd'],
  key: 's',
  callback: () async => saveDocument(),
  id: 'save_document',
);

// Cmd+Shift+N
KeyboardShortcutMapping.register(
  modifiers: ['cmd', 'shift'],
  key: 'n',
  callback: () async => createNewFile(),
  id: 'new_file',
);

// No modifiers — just F1
KeyboardShortcutMapping.register(
  modifiers: [],
  key: 'F1',
  callback: () async => openHelp(),
  id: 'help',
);
```

### Handle key events

Wire up a `KeyboardListener` in your widget tree and forward events to the package:

```dart
KeyboardListener(
  focusNode: _focusNode,
  onKeyEvent: (event) async {
    if (event is KeyDownEvent) {
      final modifiers = [
        if (HardwareKeyboard.instance.isMetaPressed) 'cmd',
        if (HardwareKeyboard.instance.isShiftPressed) 'shift',
        if (HardwareKeyboard.instance.isAltPressed) 'alt',
        if (HardwareKeyboard.instance.isControlPressed) 'ctrl',
      ];
      await KeyboardShortcutMapping.handleKeyEvent(modifiers, keyLabel);
    }
  },
  child: ...,
)
```

### Unregister shortcuts

```dart
// Remove one
KeyboardShortcutMapping.unregister('save_document');

// Remove all
KeyboardShortcutMapping.unregisterAll();
```

### Get all registered shortcuts

```dart
final shortcuts = KeyboardShortcutMapping.getShortcuts();
// Map<String, KeyboardShortcut> — keyed by id
```

---

## Persistence

The package is storage-agnostic. Use `getShortcuts()` to read the current in-memory state and serialize it yourself after any mutation.

### Example with SharedPreferences

**1. Save after registering or unregistering:**

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveShortcuts() async {
  final prefs = await SharedPreferences.getInstance();
  final data = KeyboardShortcutMapping.getShortcuts().map(
    (id, s) => MapEntry(id, {'modifiers': s.modifiers, 'key': s.key}),
  );
  await prefs.setString('keyboard_shortcuts', jsonEncode(data));
}
```

**2. Load at startup and re-attach callbacks:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load persisted config
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString('keyboard_shortcuts');
  if (stored != null) {
    final raw = jsonDecode(stored) as Map<String, dynamic>;
    for (final entry in raw.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      KeyboardShortcutMapping.register(
        id: entry.key,
        modifiers: List<String>.from(data['modifiers'] as List),
        key: data['key'] as String,
        callback: () async {}, // placeholder — real callbacks set in initState
      );
    }
  }

  runApp(const MyApp());
}
```

**3. Re-attach real callbacks in `initState`:**

```dart
@override
void initState() {
  super.initState();
  for (final entry in KeyboardShortcutMapping.getShortcuts().entries) {
    final id = entry.key;
    if (id == 'save_document') {
      KeyboardShortcutMapping.registerCallback(id: id, callback: saveDocument);
    } else if (id == 'new_file') {
      KeyboardShortcutMapping.registerCallback(id: id, callback: createNewFile);
    }
    // ... other shortcuts
  }
}
```

> Callbacks cannot be serialized, so they must be re-registered after each app restart. The persisted data (modifiers + key) is enough to reconstruct the full shortcut.

---

## Screenshots

<img width="350" height="720" alt="image 1" src="https://github.com/user-attachments/assets/7757afc9-d370-4dd1-9418-c0b600a3ef06" />
<img width="350" height="720" alt="image 2" src="https://github.com/user-attachments/assets/6f94895e-76ba-48c6-a742-4994c7709b52" />

## Contributing & Support

- Report issues and feature requests on [GitHub](https://github.com/japanshah17/keyboard_shortcut_mapping/issues)
- Pull requests welcome

## License

See [LICENSE](LICENSE) file for details.

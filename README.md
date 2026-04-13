# Keyboard Shortcut Mapping

A powerful Flutter plugin for managing keyboard shortcuts with persistent storage. Register custom keyboard shortcuts and associate them with callback functions that persist across app restarts.

## Features

✨ **Core Features:**
- 🎯 Register keyboard shortcuts with modifier keys (Cmd, Shift, Alt, Ctrl)
- 🎪 Support for letter keys (a-z), numbers (0-9), and function keys (F1-F12)
- 💾 **Automatic persistence** - Shortcuts are saved and restored across app restarts
- 🔄 Manage shortcuts dynamically - add, remove, or update shortcuts at runtime
- ⚡ Callback-based execution - Execute any async function when a shortcut is pressed
- 🛡️ Type-safe API with clear error handling

## Platform Support

- ✅ **macOS** (Full support)
- ✅ **Windows** (Full support)
- ✅ **Linux** (Full support)

## Installation

Add `keyboard_shortcut_mapping` to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_shortcut_mapping: ^0.0.3
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize on App Startup

```dart
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔧 REQUIRED: Initialize keyboard shortcuts on app startup
  await KeyboardShortcutMapping.initialize();
  
  runApp(const MyApp());
}
```

### 2. Register Shortcuts

Register a keyboard shortcut with a callback function:

```dart
// Simple shortcut: Cmd+S
await KeyboardShortcutMapping.register(
  modifiers: ['cmd'],
  key: 's',
  callback: () async { 
    await saveDocument();
  },
  id: 'save_document',
);

// Complex shortcut: Cmd+Shift+N
await KeyboardShortcutMapping.register(
  modifiers: ['cmd', 'shift'],
  key: 'n',
  callback: () async { 
    createNewFile();
  },
  id: 'new_file',
);

// Without modifiers: Just F1
await KeyboardShortcutMapping.register(
  modifiers: [],
  key: 'F1',
  callback: () async { 
    openHelp();
  },
  id: 'help',
);
```

### 3. Restore Shortcuts on App Restart

This is a **crucial step** for persistence to work properly. Since callbacks cannot be serialized, you must re-register them when the app restarts:

```dart
Future<void> _restoreShortcutCallbacks() async {
  final shortcuts = KeyboardShortcutMapping.getShortcuts();
  
  // Loop through all saved shortcuts and re-register their callbacks
  for (final entry in shortcuts.entries) {
    final id = entry.key;
    
    if (id == 'save_document') {
      await KeyboardShortcutMapping.registerCallback(
        id: id,
        callback: saveDocument,
      );
    } else if (id == 'new_file') {
      await KeyboardShortcutMapping.registerCallback(
        id: id,
        callback: createNewFile,
      );
    }
    // ... register callbacks for other shortcuts
  }
}

// Call this early in your state initialization
@override
void initState() {
  super.initState();
  _restoreShortcutCallbacks();
}
```
## Screenshots

<img width="350" height="720" alt="image 1" src="https://github.com/user-attachments/assets/7757afc9-d370-4dd1-9418-c0b600a3ef06" />
<img width="350" height="720" alt="image 2" src="https://github.com/user-attachments/assets/6f94895e-76ba-48c6-a742-4994c7709b52" />


## Contributing & Support

This package is designed to be extensible. Feel free to:
- Report issues and feature requests
- Submit pull requests for additional platform support

## License

See [LICENSE](LICENSE) file for details.

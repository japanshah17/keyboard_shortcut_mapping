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

- ✅ **macOS** (Primary support)
- ✅ **Windows**

## Installation

Add `keyboard_shortcut_mapping` to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_shortcut_mapping: ^0.0.1
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
<img width="350" height="720" alt="image" src="https://github.com/user-attachments/assets/e0fa6194-8b23-4951-ab74-3e6658c60f0e" />
<img width="350" height="720" alt="image" src="https://github.com/user-attachments/assets/42ce249c-8727-4041-b124-4279955089d2" />

## Contributing & Support

This package is designed to be extensible. Feel free to:
- Report issues and feature requests
- Submit pull requests for additional platform support

## License

See [LICENSE](LICENSE) file for details.
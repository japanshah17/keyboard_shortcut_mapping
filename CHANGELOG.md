## 2.0.0

* Refactor: Removed `shared_preferences` dependency from the package
* Refactor: `register`, `unregister`, `unregisterAll`, `registerCallback`, and `dispose` are now synchronous
* Removed: `initialize()` method — persistence is now the caller's responsibility
* Updated example app with a `_ShortcutStorage` helper demonstrating SharedPreferences-based persistence

## 1.0.0

* Feature: Added Windows platform support
* Feature: Added Linux platform support

## 0.0.2

* Fix: Shortened package description for pub.dev compliance
* Fix: Added issue_tracker URL to pubspec.yaml
* Feat: Add Windows support for keyboard shortcut mapping plugin

## 0.0.1

* Initial release of keyboard_shortcut_mapping plugin
* Support for macOS platform
* Keyboard shortcut registration with modifier keys (Cmd, Shift, Alt, Ctrl)
* Support for letter keys (a-z), numbers (0-9), and function keys (F1-F12)
* Automatic persistence of shortcuts across app restarts
* Dynamic shortcut management (add, remove, update)
* Type-safe API with clear error handling

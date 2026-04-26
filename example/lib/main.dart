import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcut_mapping/keyboard_shortcut_mapping.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Persistence helper — caller-owned. Stores shortcut config (modifiers + key)
// in SharedPreferences. Callbacks cannot be serialized; they are re-attached
// in initState via _restoreShortcutCallbacks().
// ---------------------------------------------------------------------------
class _ShortcutStorage {
  static const _key = 'keyboard_shortcuts';

  static Future<Map<String, Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return {};
    final raw = jsonDecode(json) as Map<String, dynamic>;
    return raw.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
  }

  static Future<void> save(Map<String, KeyboardShortcut> shortcuts) async {
    final prefs = await SharedPreferences.getInstance();
    final data = shortcuts.map(
      (id, s) => MapEntry(id, {'modifiers': s.modifiers, 'key': s.key}),
    );
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load persisted shortcut config and populate the package's in-memory state.
  // Real callbacks are re-attached in the page's initState.
  final saved = await _ShortcutStorage.load();
  for (final entry in saved.entries) {
    KeyboardShortcutMapping.register(
      id: entry.key,
      modifiers: List<String>.from(entry.value['modifiers'] as List),
      key: entry.value['key'] as String,
      callback: () async {},
    );
  }

  runApp(const KeyboardShortcutMappingExampleApp());
}

class KeyboardShortcutMappingExampleApp extends StatelessWidget {
  const KeyboardShortcutMappingExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keyboard Shortcuts Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const KeyboardShortcutMappingExamplePage(),
    );
  }
}

class KeyboardShortcutMappingExamplePage extends StatefulWidget {
  const KeyboardShortcutMappingExamplePage({super.key});

  @override
  State<KeyboardShortcutMappingExamplePage> createState() =>
      _KeyboardShortcutMappingExamplePageState();
}

/// 📋 CUSTOMIZE: Add your own actions here
/// Example: save('Save'), undo('Undo'), delete('Delete')
enum ActionType {
  actionOne('Action One'),
  actionTwo('Action Two'),
  actionThree('Action Three');

  final String displayName;
  const ActionType(this.displayName);
}

class _KeyListener extends StatefulWidget {
  final ActionType action;
  final Function(List<String> modifiers, String key) onKeyRecorded;

  const _KeyListener({required this.action, required this.onKeyRecorded});

  @override
  State<_KeyListener> createState() => _KeyListenerState();
}

class _KeyListenerState extends State<_KeyListener> {
  late FocusNode _focusNode;
  String _recordedKey = '';
  List<String> _recordedModifiers = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      List<String> modifiers = [];

      if (HardwareKeyboard.instance.isMetaPressed) modifiers.add('cmd');
      if (HardwareKeyboard.instance.isShiftPressed) modifiers.add('shift');
      if (HardwareKeyboard.instance.isAltPressed) modifiers.add('alt');
      if (HardwareKeyboard.instance.isControlPressed) modifiers.add('ctrl');

      String key = _getKeyLabel(event.logicalKey);

      if (key.isNotEmpty) {
        setState(() {
          _recordedModifiers = modifiers;
          _recordedKey = key;
        });
      }
    }
  }

  String _getKeyLabel(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.keyA) return 'a';
    if (key == LogicalKeyboardKey.keyB) return 'b';
    if (key == LogicalKeyboardKey.keyC) return 'c';
    if (key == LogicalKeyboardKey.keyD) return 'd';
    if (key == LogicalKeyboardKey.keyE) return 'e';
    if (key == LogicalKeyboardKey.keyF) return 'f';
    if (key == LogicalKeyboardKey.keyG) return 'g';
    if (key == LogicalKeyboardKey.keyH) return 'h';
    if (key == LogicalKeyboardKey.keyI) return 'i';
    if (key == LogicalKeyboardKey.keyJ) return 'j';
    if (key == LogicalKeyboardKey.keyK) return 'k';
    if (key == LogicalKeyboardKey.keyL) return 'l';
    if (key == LogicalKeyboardKey.keyM) return 'm';
    if (key == LogicalKeyboardKey.keyN) return 'n';
    if (key == LogicalKeyboardKey.keyO) return 'o';
    if (key == LogicalKeyboardKey.keyP) return 'p';
    if (key == LogicalKeyboardKey.keyQ) return 'q';
    if (key == LogicalKeyboardKey.keyR) return 'r';
    if (key == LogicalKeyboardKey.keyS) return 's';
    if (key == LogicalKeyboardKey.keyT) return 't';
    if (key == LogicalKeyboardKey.keyU) return 'u';
    if (key == LogicalKeyboardKey.keyV) return 'v';
    if (key == LogicalKeyboardKey.keyW) return 'w';
    if (key == LogicalKeyboardKey.keyX) return 'x';
    if (key == LogicalKeyboardKey.keyY) return 'y';
    if (key == LogicalKeyboardKey.keyZ) return 'z';
    if (key == LogicalKeyboardKey.digit0) return '0';
    if (key == LogicalKeyboardKey.digit1) return '1';
    if (key == LogicalKeyboardKey.digit2) return '2';
    if (key == LogicalKeyboardKey.digit3) return '3';
    if (key == LogicalKeyboardKey.digit4) return '4';
    if (key == LogicalKeyboardKey.digit5) return '5';
    if (key == LogicalKeyboardKey.digit6) return '6';
    if (key == LogicalKeyboardKey.digit7) return '7';
    if (key == LogicalKeyboardKey.digit8) return '8';
    if (key == LogicalKeyboardKey.digit9) return '9';
    if (key == LogicalKeyboardKey.f1) return 'F1';
    if (key == LogicalKeyboardKey.f2) return 'F2';
    if (key == LogicalKeyboardKey.f3) return 'F3';
    if (key == LogicalKeyboardKey.enter) return 'Return';
    if (key == LogicalKeyboardKey.space) return 'space';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: AlertDialog(
        title: const Text('Record Keyboard Shortcut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Press the keyboard shortcut you want to use for:\n${widget.action.displayName}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_recordedKey.isEmpty)
              const Text(
                'Waiting for input...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Recorded:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recordedModifiers.isNotEmpty
                          ? '${_recordedModifiers.map((m) => m.toUpperCase()).join('+')}+${_recordedKey.toUpperCase()}'
                          : _recordedKey.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Examples: Cmd+S, Cmd+Z, Cmd+Shift+N',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          if (_recordedKey.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onKeyRecorded(_recordedModifiers, _recordedKey);
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
    );
  }
}

class _KeyboardShortcutMappingExamplePageState
    extends State<KeyboardShortcutMappingExamplePage> {
  String _lastAction = 'No action triggered yet';
  bool _isListeningForKeys = false;
  late FocusNode _pageFocusNode;

  final List<String> _registeredShortcutIds = [];

  @override
  void initState() {
    super.initState();
    _pageFocusNode = FocusNode();
    _restoreShortcutCallbacks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageFocusNode.requestFocus();
    });
  }

  /// Attach real callbacks to shortcuts loaded from storage in main().
  void _restoreShortcutCallbacks() {
    for (final entry in KeyboardShortcutMapping.getShortcuts().entries) {
      final id = entry.key;
      if (id.startsWith('actionOne')) {
        KeyboardShortcutMapping.registerCallback(id: id, callback: _actionOne);
        _registeredShortcutIds.add(id);
      } else if (id.startsWith('actionTwo')) {
        KeyboardShortcutMapping.registerCallback(id: id, callback: _actionTwo);
        _registeredShortcutIds.add(id);
      } else if (id.startsWith('actionThree')) {
        KeyboardShortcutMapping.registerCallback(
            id: id, callback: _actionThree);
        _registeredShortcutIds.add(id);
      }
    }
    if (_registeredShortcutIds.isNotEmpty) setState(() {});
  }

  /// 🔧 CUSTOMIZE: Replace with your own action logic
  Future<void> _actionOne() async => _updateAction('Action One Triggered!');
  Future<void> _actionTwo() async => _updateAction('Action Two Triggered!');
  Future<void> _actionThree() async => _updateAction('Action Three Triggered!');

  ShortcutCallback _getCallbackForAction(ActionType action) {
    switch (action) {
      case ActionType.actionOne:
        return _actionOne;
      case ActionType.actionTwo:
        return _actionTwo;
      case ActionType.actionThree:
        return _actionThree;
    }
  }

  Future<void> _startListeningForKeys(ActionType action) async {
    setState(() => _isListeningForKeys = true);

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _KeyListener(
        action: action,
        onKeyRecorded: (modifiers, key) {
          _registerShortcutForAction(action, modifiers, key);
        },
      ),
    );

    if (mounted) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _pageFocusNode.requestFocus());
    }
  }

  Future<void> _registerShortcutForAction(
    ActionType action,
    List<String> modifiers,
    String key,
  ) async {
    try {
      final id = '${action.name}_${modifiers.join('_')}_$key';

      // Register in the package (in-memory)
      KeyboardShortcutMapping.register(
        modifiers: modifiers,
        key: key,
        callback: _getCallbackForAction(action),
        id: id,
      );

      // Persist to SharedPreferences
      await _ShortcutStorage.save(KeyboardShortcutMapping.getShortcuts());

      _registeredShortcutIds.add(id);
      final display =
          '${modifiers.map((m) => m.toUpperCase()).join('+')}+${key.toUpperCase()}';
      _updateAction('Registered ${action.displayName} to $display');
      setState(() => _isListeningForKeys = false);
    } on Exception catch (e) {
      _updateAction('Error registering shortcut: $e');
      setState(() => _isListeningForKeys = false);
    }
  }

  void _updateAction(String action) => setState(() => _lastAction = action);

  Future<void> _unregisterShortcut(String id) async {
    try {
      KeyboardShortcutMapping.unregister(id);
      await _ShortcutStorage.save(KeyboardShortcutMapping.getShortcuts());
      _registeredShortcutIds.remove(id);
      setState(() {});
      _updateAction('Unregistered $id');
    } on Exception catch (e) {
      _updateAction('Error unregistering $id: $e');
    }
  }

  Future<void> _unregisterAll() async {
    try {
      KeyboardShortcutMapping.unregisterAll();
      await _ShortcutStorage.clear();
      _registeredShortcutIds.clear();
      setState(() {});
      _updateAction('All shortcuts unregistered');
    } on Exception catch (e) {
      _updateAction('Error unregistering all: $e');
    }
  }

  Future<void> _handlePageKeyEvent(KeyEvent event) async {
    if (event is KeyDownEvent && !_isListeningForKeys) {
      List<String> modifiers = [];
      if (HardwareKeyboard.instance.isMetaPressed) modifiers.add('cmd');
      if (HardwareKeyboard.instance.isShiftPressed) modifiers.add('shift');
      if (HardwareKeyboard.instance.isAltPressed) modifiers.add('alt');
      if (HardwareKeyboard.instance.isControlPressed) modifiers.add('ctrl');

      final key = _getKeyLabel(event.logicalKey);
      if (key != null && key.isNotEmpty) {
        await KeyboardShortcutMapping.handleKeyEvent(modifiers, key);
      }
    }
  }

  @override
  void dispose() {
    _pageFocusNode.dispose();
    super.dispose();
  }

  String? _getKeyLabel(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.keyA) return 'a';
    if (key == LogicalKeyboardKey.keyB) return 'b';
    if (key == LogicalKeyboardKey.keyC) return 'c';
    if (key == LogicalKeyboardKey.keyD) return 'd';
    if (key == LogicalKeyboardKey.keyE) return 'e';
    if (key == LogicalKeyboardKey.keyF) return 'f';
    if (key == LogicalKeyboardKey.keyG) return 'g';
    if (key == LogicalKeyboardKey.keyH) return 'h';
    if (key == LogicalKeyboardKey.keyI) return 'i';
    if (key == LogicalKeyboardKey.keyJ) return 'j';
    if (key == LogicalKeyboardKey.keyK) return 'k';
    if (key == LogicalKeyboardKey.keyL) return 'l';
    if (key == LogicalKeyboardKey.keyM) return 'm';
    if (key == LogicalKeyboardKey.keyN) return 'n';
    if (key == LogicalKeyboardKey.keyO) return 'o';
    if (key == LogicalKeyboardKey.keyP) return 'p';
    if (key == LogicalKeyboardKey.keyQ) return 'q';
    if (key == LogicalKeyboardKey.keyR) return 'r';
    if (key == LogicalKeyboardKey.keyS) return 's';
    if (key == LogicalKeyboardKey.keyT) return 't';
    if (key == LogicalKeyboardKey.keyU) return 'u';
    if (key == LogicalKeyboardKey.keyV) return 'v';
    if (key == LogicalKeyboardKey.keyW) return 'w';
    if (key == LogicalKeyboardKey.keyX) return 'x';
    if (key == LogicalKeyboardKey.keyY) return 'y';
    if (key == LogicalKeyboardKey.keyZ) return 'z';
    if (key == LogicalKeyboardKey.digit0) return '0';
    if (key == LogicalKeyboardKey.digit1) return '1';
    if (key == LogicalKeyboardKey.digit2) return '2';
    if (key == LogicalKeyboardKey.digit3) return '3';
    if (key == LogicalKeyboardKey.digit4) return '4';
    if (key == LogicalKeyboardKey.digit5) return '5';
    if (key == LogicalKeyboardKey.digit6) return '6';
    if (key == LogicalKeyboardKey.digit7) return '7';
    if (key == LogicalKeyboardKey.digit8) return '8';
    if (key == LogicalKeyboardKey.digit9) return '9';
    if (key == LogicalKeyboardKey.f1) return 'F1';
    if (key == LogicalKeyboardKey.f2) return 'F2';
    if (key == LogicalKeyboardKey.f3) return 'F3';
    if (key == LogicalKeyboardKey.enter) return 'Return';
    if (key == LogicalKeyboardKey.space) return 'space';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _pageFocusNode,
      onKeyEvent: _handlePageKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Shortcut Mapper'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action Selection Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Action & Record Shortcut',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isListeningForKeys
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Choose Action'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: ActionType.values
                                              .map(
                                                (action) => SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _startListeningForKeys(
                                                          action,
                                                        );
                                                      },
                                                      child: Text(
                                                        action.displayName,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.add_circle),
                            label: const Text('Record New Shortcut'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Last Action Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Action',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            _lastAction,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Registered Shortcuts
                Text(
                  'Registered Shortcuts',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (_registeredShortcutIds.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'No shortcuts registered yet. Click "Record New Shortcut" to get started!',
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: _registeredShortcutIds
                        .map(
                          (id) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              child: ListTile(
                                title: Text(id),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _unregisterShortcut(id),
                                  tooltip: 'Remove shortcut',
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _registeredShortcutIds.isEmpty
                            ? null
                            : _unregisterAll,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

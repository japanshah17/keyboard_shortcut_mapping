#ifndef FLUTTER_PLUGIN_KEYBOARD_SHORTCUT_MAPPING_PLUGIN_H_
#define FLUTTER_PLUGIN_KEYBOARD_SHORTCUT_MAPPING_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace keyboard_shortcut_mapping {

class KeyboardShortcutMappingPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  KeyboardShortcutMappingPlugin();

  virtual ~KeyboardShortcutMappingPlugin();

  // Disallow copy and assign.
  KeyboardShortcutMappingPlugin(const KeyboardShortcutMappingPlugin&) = delete;
  KeyboardShortcutMappingPlugin& operator=(const KeyboardShortcutMappingPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace keyboard_shortcut_mapping

#endif  // FLUTTER_PLUGIN_KEYBOARD_SHORTCUT_MAPPING_PLUGIN_H_

#include "include/keyboard_shortcut_mapping/keyboard_shortcut_mapping_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "keyboard_shortcut_mapping_plugin.h"

void KeyboardShortcutMappingPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  keyboard_shortcut_mapping::KeyboardShortcutMappingPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

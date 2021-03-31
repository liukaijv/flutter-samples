package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import me.yohom.amap_core_fluttify.AmapCoreFluttifyPlugin;
import me.yohom.amap_location_fluttify.AmapLocationFluttifyPlugin;
import me.yohom.amap_map_fluttify.AmapMapFluttifyPlugin;
import me.yohom.amap_search_fluttify.AmapSearchFluttifyPlugin;
import me.yohom.core_location_fluttify.CoreLocationFluttifyPlugin;
import me.yohom.foundation_fluttify.FoundationFluttifyPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AmapCoreFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_core_fluttify.AmapCoreFluttifyPlugin"));
    AmapLocationFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_location_fluttify.AmapLocationFluttifyPlugin"));
    AmapMapFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_map_fluttify.AmapMapFluttifyPlugin"));
    AmapSearchFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.amap_search_fluttify.AmapSearchFluttifyPlugin"));
    CoreLocationFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.core_location_fluttify.CoreLocationFluttifyPlugin"));
    FoundationFluttifyPlugin.registerWith(registry.registrarFor("me.yohom.foundation_fluttify.FoundationFluttifyPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}

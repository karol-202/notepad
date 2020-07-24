import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:notepad/model/config.dart';
import 'package:notepad/provider/config/config_provider.dart';

class AssetsConfigProvider implements ConfigProvider {
  static const _CONFIG_ASSET = "assets/config.json";

  Config _cachedConfig;

  @override
  Future<String> getApiKey() async => (await _getOrLoadConfig()).apiKey;

  Future<Config> _getOrLoadConfig() async {
    if(_cachedConfig == null) _cachedConfig = await _loadConfig();
    return _cachedConfig;
  }

  Future<Config> _loadConfig() async {
    final configString = await rootBundle.loadString(_CONFIG_ASSET, cache: false);
    final configJson = json.decode(configString) as Map<String, dynamic>;
    return Config.fromJson(configJson);
  }
}

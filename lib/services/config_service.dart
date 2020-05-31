import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class ConfigService {
  final RemoteConfig _remoteConfig;

  // Duration to wait before activating fetched remote config.
  static const Duration _config_expiration = Duration(hours: 5);

  static const _defaultConfiguration = <String, dynamic>{
    // Maximum number of todos a user can have.
    'max_todos': 15,
    // Where to find todo list of a user with a specific user_id.
    'user_todo_list_uri': 'users/%userId/todos/',
  };

  ConfigService._(this._remoteConfig);

  // Factory method for ConfigurationService.
  // Make sure _remoteConfig is fresh.
  static Future<ConfigService> create(
      FirebaseUser user, Future<RemoteConfig> futureRemoteConfig) async {
    RemoteConfig remoteConfig = await futureRemoteConfig;
    await remoteConfig.setDefaults(_defaultConfiguration);
    await remoteConfig.fetch(expiration: _config_expiration);
    await remoteConfig.activateFetched();
    return ConfigService._(remoteConfig);
  }

  // Factory method for ConfigurationService in dev mode.
  static Future<ConfigService> createDev(
      FirebaseUser user, Future<RemoteConfig> futureRemoteConfig) async {
    RemoteConfig remoteConfig = await futureRemoteConfig;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    await remoteConfig.setDefaults(_defaultConfiguration);
    await remoteConfig.fetch(expiration: _config_expiration);
    await remoteConfig.activateFetched();
    return ConfigService._(remoteConfig);
  }

  int getMaxTodos() {
    return _remoteConfig.getInt('max_todos');
  }

  String getUserTodoListURI(String userId) {
    return _remoteConfig
        .getString('user_todo_list_uri')
        .replaceAll('%userId', userId);
  }
}

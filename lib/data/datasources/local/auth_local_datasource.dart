import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/errors/exceptions.dart';
import '../../models/usuario_model.dart';

/// Local data source for caching authentication data
/// Uses SharedPreferences for persistent storage
abstract class AuthLocalDatasource {
  /// Cache the current user
  /// Throws [CacheException] on failure
  Future<void> cacheUser(UsuarioModel user);

  /// Get the cached user
  /// Throws [CacheException] if no cached data exists
  Future<UsuarioModel> getCachedUser();

  /// Check if there is a cached user
  Future<bool> hasCachedUser();

  /// Clear cached user data
  Future<void> clearCache();

  /// Cache authentication token (optional)
  Future<void> cacheToken(String token);

  /// Get cached token
  Future<String?> getCachedToken();

  /// Clear token
  Future<void> clearToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _cachedTokenKey = 'CACHED_TOKEN';

  final SharedPreferences sharedPreferences;

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UsuarioModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<UsuarioModel> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedUserKey);

      if (jsonString == null) {
        throw CacheException(message: 'No cached user found');
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UsuarioModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  @override
  Future<bool> hasCachedUser() async {
    try {
      return sharedPreferences.containsKey(_cachedUserKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
      await sharedPreferences.remove(_cachedTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(_cachedTokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache token: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return sharedPreferences.getString(_cachedTokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(_cachedTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear token: $e');
    }
  }
}

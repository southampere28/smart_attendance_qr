import 'dart:convert';
import 'dart:developer';
import 'package:absensi_qr/models/class_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassCacheService {
  // Cache keys
  static const String _cacheKeyClasses = 'cached_classes';
  static const String _cacheKeyTimestamp = 'cached_classes_timestamp';
  static const int _cacheDurationDays = 6; // TTL 6 hari

  /// Load cached classes from SharedPreferences
  /// Returns null if cache is expired or not found
  Future<List<ClassModel>?> loadCachedClasses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKeyClasses);
      final cachedTimestamp = prefs.getInt(_cacheKeyTimestamp) ?? 0;

      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = now - cachedTimestamp;
      final maxAge = _cacheDurationDays * 24 * 60 * 60 * 1000; // 6 hari dalam ms

      if (cachedJson != null && cacheAge < maxAge) {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        // Fix type casting for grade (String -> int)
        final classes = decoded.map((e) {
          final map = Map<String, dynamic>.from(e);
          // Ensure grade is int
          if (map['grade'] is String) {
            map['grade'] = int.parse(map['grade']);
          }
          return ClassModel.fromMap(map);
        }).toList();
        log('Loaded ${classes.length} classes from cache (age: ${(cacheAge / (24 * 60 * 60 * 1000)).toStringAsFixed(1)} days)');
        return classes;
      } else {
        log('Cache expired or not found');
        return null;
      }
    } catch (e) {
      log('Error loading cache: $e');
      return null;
    }
  }

  /// Save classes to cache with current timestamp
  Future<void> saveCachedClasses(List<ClassModel> classes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = classes.map((e) => e.toMap()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_cacheKeyClasses, jsonString);
      await prefs.setInt(_cacheKeyTimestamp, DateTime.now().millisecondsSinceEpoch);
      log('Saved ${classes.length} classes to cache');
    } catch (e) {
      log('Error saving cache: $e');
    }
  }

  /// Clear cache (useful for logout or force refresh)
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKeyClasses);
      await prefs.remove(_cacheKeyTimestamp);
      log('Cache cleared');
    } catch (e) {
      log('Error clearing cache: $e');
    }
  }

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedTimestamp = prefs.getInt(_cacheKeyTimestamp) ?? 0;

      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = now - cachedTimestamp;
      final maxAge = _cacheDurationDays * 24 * 60 * 60 * 1000;

      return cacheAge < maxAge;
    } catch (e) {
      log('Error checking cache validity: $e');
      return false;
    }
  }
}

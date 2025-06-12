import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/models/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // In-memory fallback storage when SharedPreferences fails
  String? _inMemoryToken;
  String? _inMemoryTokenType;
  int? _inMemoryUserId;

  // Keys for SharedPreferences
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'access_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userId = 'user_id';
  static const String _tokenType = 'token_type';

  Future<void> saveUser(User user) async {
    try {
      // Update reactive state
      currentUser.value = user;
      isLoggedIn.value = true;

      // Update in-memory fallback
      _inMemoryToken = user.accessToken;
      _inMemoryTokenType = user.tokenType;
      _inMemoryUserId = user.userId;

      print('In-memory token saved: ${user.accessToken}');

      // Try to save to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();

        // Save user data
        await prefs.setString(_userKey, jsonEncode(user.toJson()));
        await prefs.setString(_tokenKey, user.accessToken);
        await prefs.setString(_tokenType, user.tokenType);
        await prefs.setInt(_userId, user.userId);
        await prefs.setBool(_isLoggedInKey, true);

        print('User data saved to SharedPreferences: ${user.accessToken}');
      } catch (prefError) {
        print('SharedPreferences error (using in-memory fallback): $prefError');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> clearUser() async {
    try {
      // Update reactive state
      currentUser.value = null;
      isLoggedIn.value = false;

      // Clear in-memory fallback
      _inMemoryToken = null;
      _inMemoryTokenType = null;
      _inMemoryUserId = null;

      // Try to clear SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();

        // Clear user data
        await prefs.remove(_userKey);
        await prefs.remove(_tokenKey);
        await prefs.remove(_isLoggedInKey);
        await prefs.remove(_userId);
        await prefs.remove(_tokenType);

        print('User data cleared from SharedPreferences');
      } catch (prefError) {
        print('SharedPreferences error during clear: $prefError');
      }
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  bool get hasUser => currentUser.value != null && isLoggedIn.value;

  // Get the stored access token
  Future<String?> getAccessToken() async {
    try {
      // Try SharedPreferences first
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_tokenKey);
        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (prefError) {
        print('SharedPreferences error getting token: $prefError');
      }

      // Fall back to in-memory token if available
      return _inMemoryToken;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  // Get full authorization header for API requests
  Future<String?> getAuthHeader() async {
    try {
      // Try SharedPreferences first
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_tokenKey);
        final type = prefs.getString(_tokenType) ?? 'Bearer';

        if (token != null && token.isNotEmpty) {
          return '$type $token';
        }
      } catch (prefError) {
        print('SharedPreferences error getting auth header: $prefError');
      }

      // Fall back to in-memory token if available
      if (_inMemoryToken != null && _inMemoryToken!.isNotEmpty) {
        return '${_inMemoryTokenType ?? 'Bearer'} $_inMemoryToken';
      }

      return null;
    } catch (e) {
      print('Error getting auth header: $e');
      return null;
    }
  }

  Future<StorageService> init() async {
    try {
      // Try to initialize from SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();

        // Check if user is logged in
        final isUserLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

        if (isUserLoggedIn) {
          // Get stored user data
          final userData = prefs.getString(_userKey);

          if (userData != null) {
            // Parse user data
            final Map<String, dynamic> userMap = jsonDecode(userData);

            // Update reactive state
            currentUser.value = User.fromJson(userMap);
            isLoggedIn.value = true;

            // Update in-memory fallback
            _inMemoryToken = currentUser.value?.accessToken;
            _inMemoryTokenType = currentUser.value?.tokenType;
            _inMemoryUserId = currentUser.value?.userId;

            print(
              'User loaded from SharedPreferences: ${currentUser.value?.accessToken}',
            );
          } else {
            // Fallback if we have login state but no user data
            final token = prefs.getString(_tokenKey);
            final type = prefs.getString(_tokenType) ?? 'Bearer';
            final id = prefs.getInt(_userId) ?? 0;

            if (token != null && token.isNotEmpty) {
              currentUser.value = User(
                accessToken: token,
                tokenType: type,
                userId: id,
              );
              isLoggedIn.value = true;

              // Update in-memory fallback
              _inMemoryToken = token;
              _inMemoryTokenType = type;
              _inMemoryUserId = id;

              print('User reconstructed from token: $token');
            }
          }
        }
      } catch (prefError) {
        print('SharedPreferences error during init: $prefError');
      }
    } catch (e) {
      print('Error initializing storage service: $e');
    }

    return this;
  }
}

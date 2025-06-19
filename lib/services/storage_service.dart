import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/models/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // Keys for SharedPreferences
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'access_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userId = 'user_id';
  static const String _tokenType = 'token_type';
  static const String _cardNumberKey = 'card_number';

  // In-memory fallback storage when SharedPreferences fails
  String? _inMemoryToken;
  String? _inMemoryTokenType;
  int? _inMemoryUserId;
  String? _inMemoryCardNumber;

  Future<void> saveUser(User user) async {
    try {
      // Update reactive state
      currentUser.value = user;
      isLoggedIn.value = true;

      // Update in-memory fallback
      _inMemoryToken = user.accessToken;
      _inMemoryTokenType = user.tokenType;
      _inMemoryUserId = user.userId;
      _inMemoryCardNumber = user.cardNumber;

      print('In-memory token saved: ${user.accessToken}');
      print('In-memory card number saved: ${user.cardNumber}');

      // Try to save to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();

        // Save user data
        await prefs.setString(_userKey, jsonEncode(user.toJson()));
        await prefs.setString(_tokenKey, user.accessToken);
        await prefs.setString(_tokenType, user.tokenType);
        await prefs.setInt(_userId, user.userId);
        await prefs.setString(_cardNumberKey, user.cardNumber);
        await prefs.setBool(_isLoggedInKey, true);

        print('User data saved to SharedPreferences: ${user.accessToken}');
        print('Card number saved to SharedPreferences: ${user.cardNumber}');
      } catch (prefError) {
        print('SharedPreferences error (using in-memory fallback): $prefError');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> clearUser() async {
    try {

      currentUser.value = null;
      isLoggedIn.value = false;


      _inMemoryToken = null;
      _inMemoryTokenType = null;
      _inMemoryUserId = null;
      _inMemoryCardNumber = null;


      try {
        final prefs = await SharedPreferences.getInstance();


        await prefs.remove(_userKey);
        await prefs.remove(_tokenKey);
        await prefs.remove(_isLoggedInKey);
        await prefs.remove(_userId);
        await prefs.remove(_tokenType);
        await prefs.remove(_cardNumberKey);

        print('User data cleared from SharedPreferences');
      } catch (prefError) {
        print('SharedPreferences error during clear: $prefError');
      }
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  bool get hasUser => currentUser.value != null && isLoggedIn.value;


  Future<String?> getAccessToken() async {
    try {

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_tokenKey);
        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (prefError) {
        print('SharedPreferences error getting token: $prefError');
      }

      return _inMemoryToken;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Future<String?> getAuthHeader() async {
    try {

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


      if (_inMemoryToken != null && _inMemoryToken!.isNotEmpty) {
        return '${_inMemoryTokenType ?? 'Bearer'} $_inMemoryToken';
      }

      return null;
    } catch (e) {
      print('Error getting auth header: $e');
      return null;
    }
  }

  Future<String?> getCardNumber() async {
    try {

      if (currentUser.value != null) {
        return currentUser.value!.cardNumber;
      }


      try {
        final prefs = await SharedPreferences.getInstance();
        final cardNumber = prefs.getString(_cardNumberKey);
        if (cardNumber != null && cardNumber.isNotEmpty) {
          return cardNumber;
        }
      } catch (prefError) {
        print('SharedPreferences error getting card number: $prefError');
      }


      return _inMemoryCardNumber;
    } catch (e) {
      print('Error getting card number: $e');
      return null;
    }
  }


  String get cardNumber =>
      currentUser.value?.cardNumber ?? _inMemoryCardNumber ?? '';


  void updateCurrentUser(User user) {

    currentUser.value = user;


    print(
      'Updated current user in StorageService: ${user.name}, ${user.cardNumber}',
    );
  }

  Future<StorageService> init() async {
    try {
      print('Initializing StorageService...');

      try {
        final prefs = await SharedPreferences.getInstance();


        final isUserLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
        print('SharedPreferences - Is user logged in: $isUserLoggedIn');

        if (isUserLoggedIn) {

          final userData = prefs.getString(_userKey);
          print('SharedPreferences - User data exists: ${userData != null}');

          if (userData != null) {

            final Map<String, dynamic> userMap = jsonDecode(userData);


            currentUser.value = User.fromJson(userMap);
            isLoggedIn.value = true;


            _inMemoryToken = currentUser.value?.accessToken;
            _inMemoryTokenType = currentUser.value?.tokenType;
            _inMemoryUserId = currentUser.value?.userId;
            _inMemoryCardNumber = currentUser.value?.cardNumber;

            print(
              'User loaded from SharedPreferences: ID=${currentUser.value?.userId}, Token=${currentUser.value?.accessToken?.substring(0, 10)}...',
            );
          } else {

            final token = prefs.getString(_tokenKey);
            final type = prefs.getString(_tokenType) ?? 'Bearer';
            final id = prefs.getInt(_userId) ?? 0;
            final cardNum = prefs.getString(_cardNumberKey) ?? '';

            print(
              'SharedPreferences - Fallback token exists: ${token != null}',
            );

            if (token != null && token.isNotEmpty) {
              currentUser.value = User(
                accessToken: token,
                tokenType: type,
                userId: id,
                cardNumber: cardNum,
              );
              isLoggedIn.value = true;


              _inMemoryToken = token;
              _inMemoryTokenType = type;
              _inMemoryUserId = id;
              _inMemoryCardNumber = cardNum;

              print(
                'User reconstructed from token: ${token.substring(0, 10)}..., ID=$id, Card=$cardNum',
              );
            } else {
              print('No valid token found despite isLoggedIn flag being true');

              isLoggedIn.value = false;
              await prefs.setBool(_isLoggedInKey, false);
            }
          }
        } else {
          print('User is not logged in according to SharedPreferences');
        }
      } catch (prefError) {
        print('SharedPreferences error during init: $prefError');
      }
    } catch (e) {
      print('Error initializing storage service: $e');
    }

    print(
      'StorageService initialized. hasUser = ${hasUser}, isLoggedIn = ${isLoggedIn.value}',
    );
    return this;
  }
}

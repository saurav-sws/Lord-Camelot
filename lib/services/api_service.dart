import 'package:dio/dio.dart';
import 'package:get/get.dart';
import './storage_service.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://swsinfotech.in/point-app/api';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _initDio();
  }

  void _initDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('login') &&
              !options.path.contains('send-otp') &&
              !options.path.contains('resend-otp') &&
              !options.path.contains('verifyOtpAndRegister')) {
            final storageService = Get.find<StorageService>();

            final authHeader = await storageService.getAuthHeader();

            if (authHeader != null) {
              options.headers['Authorization'] = authHeader;
              print('Added auth header: $authHeader');
            }
          }

          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String cardNumber, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'card_number': cardNumber, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> sendOTP({
    required String name,
    required String mobile,
    required String cardNumber,
    required String fcmToken,
  }) async {
    try {
      final response = await _dio.post(
        '/send-otp',
        data: {
          'name': name,
          'mobile': mobile,
          'card_number': cardNumber,
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data.containsKey('errors')) {
          Map<String, dynamic> errors = e.response!.data['errors'];
          String errorMessage = '';

          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessage += '${value[0]} ';
            }
          });

          throw Exception(errorMessage.trim());
        }
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> requestOTP({
    required String mobile,
    required String name,
    required String cardNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/requestOtp',
        data: {'mobile': mobile, 'name': name, 'card_number': cardNumber},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to request OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtpAndRegister({
    required String mobile,
    required String name,
    required String cardNumber,
    required String fcmToken,
    required String otp,
    String? dob,
  }) async {
    try {
      final response = await _dio.post(
        '/verifyOtpAndRegister',
        data: {
          'mobile': mobile,
          'name': name,
          'card_number': cardNumber,
          'fcm_token': fcmToken,
          'otp': otp,
          'dob': dob ?? '',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> resendOTP({required String mobile}) async {
    try {
      final response = await _dio.post('/resend-otp', data: {'mobile': mobile});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data.containsKey('errors')) {
          Map<String, dynamic> errors = e.response!.data['errors'];
          String errorMessage = '';

          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessage += '${value[0]} ';
            }
          });

          throw Exception(errorMessage.trim());
        }
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getPoints() async {
    try {
      final response = await _dio.get('/points');

      if (response.statusCode == 200) {
        print('Points fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to fetch points: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from points API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error fetching points: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error fetching points: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getRedeemHistory() async {
    try {
      final response = await _dio.get('/redeem-history');

      if (response.statusCode == 200) {
        print('Redeem history fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch redeem history: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from redeem history API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error fetching redeem history: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error fetching redeem history: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String mobile,
    required String cardNumber,
    required int totalPoint,
    required String dob,
  }) async {
    try {
      final response = await _dio.post(
        '/update',
        data: {
          'name': name,
          'mobile': mobile,
          'card_number': cardNumber,
          'total_point': totalPoint,
          'dob': dob,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Profile updated successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from update profile API: ${e.response?.data}');
        if (e.response!.data is Map && e.response!.data.containsKey('errors')) {
          Map<String, dynamic> errors = e.response!.data['errors'];
          String errorMessage = '';

          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessage += '${value[0]} ';
            }
          });

          throw Exception(errorMessage.trim());
        }
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error updating profile: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error updating profile: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getPointHistory() async {
    try {
      final response = await _dio.get('/point_history');

      if (response.statusCode == 200) {
        print('Point history fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch point history: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from point history API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error fetching point history: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error fetching point history: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      print('Fetching user profile data...');
      final response = await _dio.get('/get-profile');

      if (response.statusCode == 200) {
        print('Profile data fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to fetch profile data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from get-profile API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error fetching profile data: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error fetching profile data: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> redeemPoints({
    required List<int> pointIds,
    required double totalAmount,
    required double discount,
    required int totalPoint,
    required String cardNumber,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/redeem-points',
        data: {
          'point_ids': pointIds,
          'total_amount': totalAmount,
          'discount': discount,
          'total_point': totalPoint,
          'card_number': cardNumber,
          'user_id': userId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Points redeemed successfully: ${response.data}');

        if (response.data is Map<String, dynamic>) {
          if (!response.data.containsKey('success')) {
            if (response.data.containsKey('message') &&
                response.data['message'].toString().toLowerCase().contains(
                  'successful',
                )) {
              response.data['success'] = true;
            }
          }
        }

        return response.data;
      } else {
        throw Exception('Failed to redeem points: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from redeem points API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error redeeming points: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error redeeming points: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getNews() async {
    try {
      print('Fetching news data...');
      final response = await _dio.get('/news');

      if (response.statusCode == 200) {
        print('News data fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to fetch news data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response from news API: ${e.response?.data}');
        throw Exception(
          'Error: ${e.response?.data['message'] ?? 'Unknown error'}',
        );
      } else {
        print('Network error fetching news data: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error fetching news data: $e');
      throw Exception('Error: $e');
    }
  }
}

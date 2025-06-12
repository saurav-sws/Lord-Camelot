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

    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Don't add auth headers for login and registration
          if (!options.path.contains('login') &&
              !options.path.contains('send-otp') &&
              !options.path.contains('resend-otp') &&
              !options.path.contains('verifyOtpAndRegister')) {
            // Get the storage service
            final storageService = Get.find<StorageService>();

            // Get auth header
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

  // Fetch user points
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
      print('Unexpected error fetching points: $e');
      throw Exception('Error: $e');
    }
  }
}

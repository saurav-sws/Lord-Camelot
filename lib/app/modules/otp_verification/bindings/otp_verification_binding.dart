import 'package:get/get.dart';
import '../controllers/otp_verification_controller.dart';
import '../../../../services/api_service.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure ApiService is registered
    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService(), permanent: true);
    }

    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(
        phoneNumber: Get.arguments?['phoneNumber'] ?? '',
        fullName: Get.arguments?['fullName'] ?? '',
        cardNumber: Get.arguments?['cardNumber'] ?? '',
        fcmToken: Get.arguments?['fcmToken'] ?? '',
        dob: Get.arguments?['dob'],
        otpValue: Get.arguments?['otpValue'],
      ),
    );
  }
}

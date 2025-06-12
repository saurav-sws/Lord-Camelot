import 'package:get/get.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(
        phoneNumber: Get.arguments?['phoneNumber'] ?? '',
        fullName: Get.arguments?['fullName'] ?? '',
        cardNumber: Get.arguments?['cardNumber'] ?? '',
        fcmToken: Get.arguments?['fcmToken'] ?? '',
        otpValue: Get.arguments?['otpValue'],
      ),
    );
  }
}

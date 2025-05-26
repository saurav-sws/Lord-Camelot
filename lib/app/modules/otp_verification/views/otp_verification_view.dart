import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get phone number from arguments or use a default
    final String phoneNumber = Get.arguments?['phoneNumber'] ?? '09056738654';

    // Initialize the controller with phone number
    final otpController = Get.put(
      OtpVerificationController(phoneNumber: phoneNumber),
    );

    // Custom PIN theme for Pinput
    final defaultPinTheme = PinTheme(
      width: ResponsiveSize.width(60),
      height: ResponsiveSize.height(60),
      textStyle: TextStyle(
        fontSize: ResponsiveSize.fontSize(22),
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF002A20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveSize.padding(horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: ResponsiveSize.height(100)),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/Splash.png',
                    width: ResponsiveSize.width(90),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(50)),
                // OTP Verification Container
                Container(
                  padding: ResponsiveSize.padding(all: 20),
                  decoration: BoxDecoration(
                    color: Color(0XFF0F0F0F).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text("OTP Verification", style: AppTextStyles.heading),
                      SizedBox(height: ResponsiveSize.height(15)),
                      // Subtitle with phone number
                      Text(
                        "Enter the verification code sent to\n$phoneNumber",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subheading,
                      ),
                      SizedBox(height: ResponsiveSize.height(40)),

                      // OTP Input
                      Pinput(
                        controller: otpController.pinController,
                        focusNode: otpController.focusNode,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            color: Colors.grey.shade800,
                          ),
                        ),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => otpController.verifyOTP(),
                      ),

                      SizedBox(height: ResponsiveSize.height(30)),

                      // Resend OTP Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Dont received code?",
                            style: AppTextStyles.grayLabel,
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => GestureDetector(
                              onTap:
                                  otpController.isResending.value
                                      ? null
                                      : otpController.resendOTP,
                              child: Text(
                                otpController.isResending.value
                                    ? "Sending..."
                                    : "Re-Send",
                                style: AppTextStyles.linkText,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: ResponsiveSize.height(35)),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: otpController.verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(14),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Verify",
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

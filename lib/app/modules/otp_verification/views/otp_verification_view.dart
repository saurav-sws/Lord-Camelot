import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 0.8,
            colors: [Color(0xFF001e16), Color(0xFF000000)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveSize.padding(horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: ResponsiveSize.height(80)),
                Center(
                  child: Image.asset(
                    'assets/images/Splash.png',
                    width: ResponsiveSize.width(150),
                    height: ResponsiveSize.height(150),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(20)),
                Container(
                  padding: ResponsiveSize.padding(all: 20),
                  decoration: BoxDecoration(
                    color: Color(0XFF0F0F0F).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Transform(
                          transform: Matrix4.identity()..scale(1.2, 1.2),
                          child: Text(
                            'verify_otp'.tr,
                            style: AppTextStyles.heading,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Center(
                          child: Transform(
                            transform: Matrix4.identity()..scale(1.2),
                            child: Text(
                              'enter_code'.tr,
                              style: AppTextStyles.subheading,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(5)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Center(
                          child: Obx(
                            () => Text(
                              controller.formattedPhoneNumber.value,
                              style: AppTextStyles.heading.copyWith(
                                fontSize: ResponsiveSize.fontSize(19),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(30)),
                      Padding(
                        padding: ResponsiveSize.padding(horizontal: 20),
                        child: PinFieldAutoFill(
                          controller: controller.otpController,
                          codeLength: 4,
                          onCodeChanged:
                              (code) => controller.updatePin(code ?? ''),
                          decoration: UnderlineDecoration(
                            textStyle: AppTextStyles.inputText1.copyWith(
                              fontSize: ResponsiveSize.fontSize(24),
                              color: Colors.white,
                            ),
                            colorBuilder: FixedColorBuilder(Colors.white38),
                          ),
                          currentCode: controller.pin.value,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(5)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform(
                            transform: Matrix4.identity()..scale(1.1, 1.2),
                            child: Text(
                              'no_otp_received'.tr,
                              style: AppTextStyles.grayLabel,
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.width(12)),
                          Obx(
                            () => TextButton(
                              onPressed:
                                  controller.canResend.value
                                      ? controller.resendOTP
                                      : null,
                              child: Transform(
                                transform: Matrix4.identity()..scale(1.1, 1.2),
                                child: Text(
                                  controller.canResend.value
                                      ? 'resend'.tr
                                      : '${controller.resendTimer.value} ${'seconds'.tr}',
                                  style: AppTextStyles.linkText.copyWith(
                                    color:
                                        controller.canResend.value
                                            ? Color(0xFF237220)
                                            : Color(0xFF237220),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(35)),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: controller.verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF237220),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(14),
                              ),
                            ),
                          ),
                          child: Text(
                            'verify_otp'.tr,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
                          transform: Matrix4.identity()..scale( 1.2,1.2),
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
                            transform: Matrix4.identity()..scale( 1.2),
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
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          onChanged: controller.updatePin,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(17),
                            ),
                            fieldHeight: ResponsiveSize.height(60),
                            fieldWidth: ResponsiveSize.width(60),
                            activeFillColor: Color(0xFF000000),
                            inactiveFillColor: Color(0xFF000000),
                            selectedFillColor: Color(0xFF000000),
                            activeColor: Colors.white60,
                            inactiveColor: Colors.grey.shade800,
                            selectedColor: Colors.grey.shade800,
                          ),
                          cursorColor: Colors.white,
                          enableActiveFill: true,
                          keyboardType: TextInputType.number,
                          textStyle: AppTextStyles.inputText1,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(5)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform(
                            transform: Matrix4.identity()..scale( 1.1,1.2),
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
                                transform: Matrix4.identity()..scale( 1.1,1.2),
                                child: Text(
                                  controller.canResend.value
                                      ? 'resend'.tr
                                      : '${controller.resendTimer.value} ${'seconds'.tr}',
                                  style: AppTextStyles.linkText.copyWith(
                                    color:
                                    controller.canResend.value
                                        ? Color(0xFF227522)
                                        : Color(0xFF227522)
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
                            backgroundColor: Colors.green,
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

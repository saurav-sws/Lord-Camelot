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
                SizedBox(height: ResponsiveSize.height(50)),



                Center(
                  child: Image.asset(
                    'assets/images/Splash.png',
                    width: ResponsiveSize.width(90),
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
                        child: Text(
                          'verify_otp'.tr,
                          style: AppTextStyles.heading,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Center(
                        child: Text(
                          'enter_code'.tr,
                          style: AppTextStyles.subheading,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(40)),
                      Center(
                        child: Obx(
                          () => Text(
                            controller.formattedPhoneNumber.value,
                            style: AppTextStyles.heading.copyWith(
                              fontSize: ResponsiveSize.fontSize(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(30)),
                      Padding(
                        padding: ResponsiveSize.padding(horizontal: 20),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          onChanged: controller.updatePin,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(10),
                            ),
                            fieldHeight: ResponsiveSize.height(56),
                            fieldWidth: ResponsiveSize.width(45),
                            activeFillColor: Colors.grey.shade900,
                            inactiveFillColor: Colors.grey.shade900,
                            selectedFillColor: Colors.grey.shade900,
                            activeColor: Colors.white70,
                            inactiveColor: Colors.grey.shade800,
                            selectedColor: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          enableActiveFill: true,
                          keyboardType: TextInputType.number,
                          textStyle: AppTextStyles.inputText,
                        ),
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
                      SizedBox(height: ResponsiveSize.height(15)),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'no_otp_received'.tr,
                              style: AppTextStyles.grayLabel,
                            ),
                            SizedBox(width: ResponsiveSize.width(2)),
                            Obx(
                              () => TextButton(
                                onPressed:
                                    controller.canResend.value
                                        ? controller.resendOTP
                                        : null,
                                child: Text(
                                  controller.canResend.value
                                      ? 'resend'.tr
                                      : '${controller.resendTimer.value} ${'seconds'.tr}',
                                  style: AppTextStyles.linkText.copyWith(
                                    color:
                                        controller.canResend.value
                                            ? Colors.orange
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(30)),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(10),
                    ),
                    border: Border.all(color: Colors.orange),
                  ),
                  height: ResponsiveSize.height(40),
                  width: ResponsiveSize.width(128.9),
                  child: Obx(
                        () => Row(
                      children: [
                        _buildLanguageToggleOption(
                          'EN',
                          languageController.isEnglish.value,
                              () {
                            if (!languageController.isEnglish.value) {
                              languageController.toggleLanguage();
                            }
                          },
                        ),
                        _buildLanguageToggleOption(
                          'JP',
                          !languageController.isEnglish.value,
                              () {
                            if (languageController.isEnglish.value) {
                              languageController.toggleLanguage();
                            }
                          },
                        ),
                      ],
                    ),
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


  Widget _buildLanguageToggleOption(
    String language,
    bool isSelected,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveSize.width(63),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFA500) : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            language,
            style: TextStyle(
              color: isSelected ? Colors.white70 : Colors.yellow.shade400,
              fontSize: ResponsiveSize.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

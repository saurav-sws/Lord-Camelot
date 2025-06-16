import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../../../utils/birth_date_formatter.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(SignupController());

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
                SizedBox(height: ResponsiveSize.height(30)),
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
                          transform: Matrix4.identity()..scale(1.1),
                          child: Text(
                            'sign_up'.tr,
                            style: AppTextStyles.heading,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Transform(
                        transform: Matrix4.identity()..scale(1.2),
                        child: Text(
                          'signup_desc'.tr,
                          style: AppTextStyles.subheading,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(40)),

                      Obx(
                        () => TextField(
                          controller: signupController.fullNameController.value,
                          onChanged: signupController.validateFullName,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            hintText: 'enter_name'.tr,
                            hintStyle: AppTextStyles.inputHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(12),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: ResponsiveSize.padding(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: AppTextStyles.inputText,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),

                      Obx(
                        () => TextField(
                          controller:
                              signupController.cardNumberController.value,
                          onChanged: signupController.validateCardNumber,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            hintText: 'enter_card'.tr,
                            hintStyle: AppTextStyles.inputHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(12),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: ResponsiveSize.padding(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: AppTextStyles.inputText,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),

                      Obx(
                        () => TextField(
                          controller:
                              signupController.phoneNumberController.value,
                          onChanged: signupController.validatePhoneNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            hintText: 'enter_phone'.tr,
                            hintStyle: AppTextStyles.inputHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: ResponsiveSize.padding(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: AppTextStyles.inputText,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => TextField(
                          controller: signupController.dobController.value,
                          onChanged: signupController.validateDob,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [BirthDateFormatter()],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            hintText: 'enter_dob_optional'.tr + ' (YYYY-MM-DD)',
                            hintStyle: AppTextStyles.inputHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: ResponsiveSize.padding(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            helperText: 'optional'.tr,
                            helperStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(13),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          style: AppTextStyles.inputText,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(35)),

                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: signupController.getOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF227522),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(14),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 7.0,
                              right: 9,
                            ),
                            child: Transform(
                              transform: Matrix4.identity()..scale(1.2),
                              child: Text(
                                'get_otp'.tr,
                                style: AppTextStyles.buttonText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Transform(
                              transform: Matrix4.identity()..scale(1.1, 1.2),
                              child: Text(
                                'have_account'.tr,
                                style: AppTextStyles.grayLabel,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          GestureDetector(
                            onTap: signupController.goToLogin,
                            child: Transform(
                              transform: Matrix4.identity()..scale(1.1, 1.2),
                              child: Text(
                                'login'.tr,
                                style: AppTextStyles.linkText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(SignupController());
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
                SizedBox(height: ResponsiveSize.height(60)),
                Center(
                  child: Image.asset(
                    'assets/images/Splash.png',
                    width: ResponsiveSize.width(90),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(50)),
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
                        child: Text('sign_up'.tr, style: AppTextStyles.heading),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Text(
                        'signup_desc'.tr,
                        style: AppTextStyles.subheading,
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
                      SizedBox(height: ResponsiveSize.height(35)),

                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: signupController.getOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:   Color(0xFF288c25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(14),
                              ),
                            ),
                          ),
                          child: Text(
                            'get_otp'.tr,
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'have_account'.tr,
                            style: AppTextStyles.grayLabel,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: signupController.goToLogin,
                            child: Text(
                              'login'.tr,
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(20)),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(10),
                    ),
                    border: Border.all(color: Colors.orange),
                  ),
                  height: ResponsiveSize.height(40),
                  width: ResponsiveSize.width(127.9),
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

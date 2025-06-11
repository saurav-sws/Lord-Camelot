import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find() instead of Get.put() to ensure controller is not recreated
    // when returning to this screen
    final loginController =
        Get.isRegistered<LoginController>()
            ? Get.find<LoginController>()
            : Get.put(LoginController());

    final languageController = Get.put(LanguageController());

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
                SizedBox(height: ResponsiveSize.height(20)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
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
                ),
                SizedBox(height: ResponsiveSize.height(10)),
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
                        child: Text('sign_in'.tr, style: AppTextStyles.heading),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Text('login_desc'.tr, style: AppTextStyles.subheading),
                      SizedBox(height: ResponsiveSize.height(40)),
                      Obx(
                        () =>
                            loginController.isDisposed.value
                                ? SizedBox() // Don't show TextField if controller is disposed
                                : TextField(
                                  controller:
                                      loginController.cardNumberController,
                                  onChanged: loginController.validateCardNumber,
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
                        () =>
                            loginController.isDisposed.value
                                ? SizedBox() // Don't show TextField if controller is disposed
                                : TextField(
                                  controller:
                                      loginController.phoneNumberController,
                                  onChanged:
                                      loginController.validatePhoneNumber,
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
                      SizedBox(height: ResponsiveSize.height(25)),
                      Row(
                        children: [
                          Text(
                            'forget_card'.tr,
                            style: AppTextStyles.grayLabel,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: ResponsiveSize.width(5)),
                          GestureDetector(
                            onTap: loginController.getOtp,
                            child: Text(
                              'get_otp'.tr,
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(35)),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: loginController.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(14),
                              ),
                            ),
                          ),
                          child: Text(
                            'login'.tr,
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('no_account'.tr, style: AppTextStyles.grayLabel),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: loginController.goToSignUp,
                            child: Text(
                              'sign_upl'.tr,
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(15)),
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

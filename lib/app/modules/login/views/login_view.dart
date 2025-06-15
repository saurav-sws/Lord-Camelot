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
    final loginController = Get.put(LoginController());

    final languageController = Get.put(LanguageController());

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Transform(
                        transform: Matrix4.identity()..scale(1.1),
                        child: Text('sign_in'.tr, style: AppTextStyles.heading),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(10)),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Transform(
                        transform: Matrix4.identity()..scale(1.1),
                        child: Text(
                          'login_desc'.tr,
                          style: AppTextStyles.subheading,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(40)),
                    Obx(
                      () => TextField(
                        cursorColor: Colors.white70,
                        controller: loginController.cardNumberController.value,
                        onChanged: loginController.validateCardNumber,
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
                        controller: loginController.phoneNumberController.value,
                        onChanged: loginController.validatePhoneNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          hintText: 'enter_phone'.tr,
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
                    SizedBox(height: ResponsiveSize.height(25)),
                    Row(
                      children: [
                        Transform(
                          transform: Matrix4.identity()..scale(1.1, 1.2),
                          child: Text(
                            'forget_card'.tr,
                            style: AppTextStyles.grayLabel,
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.width(25)),
                        GestureDetector(
                          onTap: loginController.getOtp,
                          child: Transform(
                            transform: Matrix4.identity()..scale(1.1, 1.2),
                            child: Text(
                              'get_otp'.tr,
                              style: AppTextStyles.linkText,
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
                        onPressed: loginController.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF227522),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(14),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 7.0, right: 9),
                          child: Transform(
                            transform: Matrix4.identity()..scale(1.2),
                            child: Text(
                              'login'.tr,
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
                              'no_account'.tr,
                              style: AppTextStyles.grayLabel,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: loginController.goToSignUp,
                          child: Transform(
                            transform: Matrix4.identity()..scale(1.1, 1.2),
                            child: Text(
                              'sign_upl'.tr,
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(30)),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.radius(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.yellow,
                            size: (18),
                          ),
                          SizedBox(width: ResponsiveSize.width(8)),
                          Text(
                            'switch_lan'.tr,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveSize.fontSize(12),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.width(12)),
                          Obx(() {
                            final isEnglish =
                                languageController.isEnglish.value;
                            return GestureDetector(
                              onTap: () => languageController.toggleLanguage(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.width(6),
                                  vertical: ResponsiveSize.height(4),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.radius(12),
                                  ),
                                  border: Border.all(
                                    color: Colors.yellow,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.width(8),
                                        vertical: ResponsiveSize.height(2),
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isEnglish
                                                ? Colors.yellow
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.radius(8),
                                        ),
                                      ),
                                      child: Text(
                                        'EN',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.fontSize(12),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isEnglish
                                                  ? Colors.black
                                                  : Colors.yellow,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ResponsiveSize.width(4)),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.width(8),
                                        vertical: ResponsiveSize.height(2),
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            !isEnglish
                                                ? Colors.yellow
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.radius(8),
                                        ),
                                      ),
                                      child: Text(
                                        'JP',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.fontSize(12),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              !isEnglish
                                                  ? Colors.black
                                                  : Colors.yellow,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.height(15)),
            ],
          ),
        ),
      ),
    );
  }
}

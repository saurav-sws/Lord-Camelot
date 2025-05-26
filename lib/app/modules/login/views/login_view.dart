import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_size.dart';
import '../../../utils/typography.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

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

                    // Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Sign in to your Account",
                          style: AppTextStyles.heading,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(10)),
                      Text(
                        "Enter your Card-No and phone-No to log in",
                        style: AppTextStyles.subheading,
                      ),
                      SizedBox(height: ResponsiveSize.height(40)),
                      TextField(
                        controller: loginController.cardNumberController,
                        onChanged: loginController.validateCardNumber,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          hintText: 'Enter your Card Number',
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
                      SizedBox(height: ResponsiveSize.height(15)),
                      TextField(
                        controller: loginController.phoneNumberController,
                        onChanged: loginController.validatePhoneNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          hintText: 'Enter Your Phone Number',
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
                      SizedBox(height: ResponsiveSize.height(25)),
                      Row(
                        children: [
                          Text(
                            "Forget Your Card Number?",
                            style: AppTextStyles.grayLabel,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: loginController.getOtp,
                            child: Text(
                              "Get OTP",
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
                          child: const Text(
                            "LogIn",
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: AppTextStyles.grayLabel,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: loginController.goToSignUp,
                            child: const Text(
                              "Sign Up",
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ],
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

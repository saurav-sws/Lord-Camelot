import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF000000),
              Color(0xFF000000),
              Color(0xFF001e16),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: ResponsiveSize.padding(vertical: 26, horizontal: 5),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                margin: ResponsiveSize.margin(vertical: 15, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    'my_profile'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Container(
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                margin: ResponsiveSize.margin(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        '${'card_number'.tr} ${profileController.cardNumber.value}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final controller = Get.find<ProfileController>();
                        controller.onInit();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(20),
                          ),
                        ),
                        minimumSize: Size(
                          ResponsiveSize.width(100),
                          ResponsiveSize.height(42),
                        ),
                      ),
                      child: Text(
                        'my_profile'.tr,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: ResponsiveSize.fontSize(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.height(20)),

              Expanded(
                child: Container(
                  padding: ResponsiveSize.padding(all: 20),
                  decoration: BoxDecoration(
                    color: Color(0XFF0F0F0F).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildProfileField(
                        'full_name'.tr,
                        profileController.fullName.value,
                        () => profileController.editField('Full Name'),
                        hasEditIcon: true,
                      ),

                      SizedBox(height: ResponsiveSize.height(15)),

                      _buildProfileField(
                        'card_number'.tr,
                        profileController.cardNumber.value,
                        () => profileController.editField('Card Number'),
                        hasEditIcon: true,
                      ),

                      SizedBox(height: ResponsiveSize.height(15)),

                      _buildProfileField(
                        'mobile_number'.tr,
                        profileController.mobileNumber.value,
                        () => profileController.editField('Mobile Number'),
                        hasEditIcon: true,
                      ),

                      SizedBox(height: ResponsiveSize.height(15)),

                      _buildProfileField(
                        'birth_date'.tr,
                        profileController.birthDate.value,
                        null,
                        hasEditIcon: false,
                      ),

                      SizedBox(height: ResponsiveSize.height(15)),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
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
                                  profileController.isEnglish.value,
                                  () {
                                    if (!profileController.isEnglish.value) {
                                      profileController.toggleLanguage();
                                    }
                                  },
                                ),
                                _buildLanguageToggleOption(
                                  'JP',
                                  !profileController.isEnglish.value,
                                  () {
                                    if (profileController.isEnglish.value) {
                                      profileController.toggleLanguage();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.height(25)),

                      SizedBox(
                        width: ResponsiveSize.width(270),
                        height: ResponsiveSize.height(50),
                        child: ElevatedButton(
                          onPressed: profileController.updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'update'.tr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: profileController.logout,
                              child: Text(
                                'log_out'.tr,
                                style: TextStyle(
                                  color: const Color(0xFFFFA500),
                                  fontSize: ResponsiveSize.fontSize(15),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: profileController.aboutPoints,
                              child: Text(
                                'about_points'.tr,
                                style: TextStyle(
                                  color: const Color(0xFFFFA500),
                                  fontSize: ResponsiveSize.fontSize(15),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    String value,
    Function()? onEdit, {
    bool hasEditIcon = true,
  }) {
    return Container(
      height: ResponsiveSize.height(65),
      padding: ResponsiveSize.padding(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(13),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveSize.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          if (hasEditIcon) SizedBox(width: ResponsiveSize.width(10)),
          if (hasEditIcon)
            InkWell(
              onTap: onEdit,
              child: Icon(
                Icons.edit_outlined,
                color: Colors.black,
                size: ResponsiveSize.width(22),
              ),
            ),
        ],
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

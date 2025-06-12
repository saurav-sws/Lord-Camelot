import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
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
          child: Padding(
            padding: ResponsiveSize.padding(vertical: 26, horizontal: 5),
            child: Column(

              children: [
                Container(
                  height: ResponsiveSize.height(40),
                ),
                Container(
                  height: ResponsiveSize.height(70),
                  width: double.infinity,


                  decoration: BoxDecoration(
                    color: Colors.black54,
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
                    color: Colors.black54,
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
                          side: const BorderSide(color: Color(0xFF288c25)),
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
                        child: Transform(
                          transform: Matrix4.identity()..scale(1.1),
                          child: Text(
                            'my_profile'.tr,
                            style: TextStyle(
                              color:  Color(0xFF227522),
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(5)),
                Container(
                  padding: ResponsiveSize.padding(all: 20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => _buildProfileField(
                          'full_name'.tr,
                          profileController.fullName.value,
                          () => profileController.editField('Full Name'),
                          hasEditIcon: true,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          'card_number'.tr,
                          profileController.cardNumber.value,
                          () => profileController.editField('Card Number'),
                          hasEditIcon: true,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          'mobile_number'.tr,
                          profileController.mobileNumber.value,
                          () => profileController.editField('Mobile Number'),
                          hasEditIcon: true,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          'birth_date'.tr,
                          profileController.birthDate.value,
                          () => profileController.editField('Birth Date'),
                          hasEditIcon: true,
                        ),
                      ),


                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 22.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Obx(() {
                      final isEnglish = languageController.isEnglish.value;
                      return GestureDetector(
                        onTap: () => languageController.toggleLanguage(),
                        child: Container(
                          width: 103,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // EN Side
                              Container(
                                width: 50,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: isEnglish ? Colors.orange : Colors.black,
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    color: isEnglish ? Colors.white : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // JP Side
                              Container(
                                width: 50,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: !isEnglish ? Colors.orange : Colors.black,
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'JP',
                                  style: TextStyle(
                                    color: !isEnglish ? Colors.white : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(25)),
                SizedBox(
                  width: ResponsiveSize.width(270),
                  height: ResponsiveSize.height(45),
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          profileController.isLoading.value
                              ? null
                              : profileController.updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Color(0xFF227522),
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(10),
                          ),
                        ),
                      ),
                      child:
                          profileController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Transform(
                            transform: Matrix4.identity()..scale( 1.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 7.0,right: 9),
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      height: ResponsiveSize.height(50),
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

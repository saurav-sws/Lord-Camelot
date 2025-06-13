import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lordcamelot_point/app/modules/main/views/main_view.dart';
import '../../../controllers/language_controller.dart';
import '../../../utils/responsive_size.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    final languageController = Get.put(LanguageController());
    final mainController = Get.put(MainController());
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
                Container(height: ResponsiveSize.height(40)),
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
                  child: Center(
                    child: Obx(
                      () => Text(
                        '${'card_number'.tr}: ${profileController.cardNumber.value}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(13),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
                          profileController,
                          'Full Name',
                          profileController.fullName.value,
                          () => profileController.editField('Full Name'),
                          hasEditIcon: true,
                          translatedLabel: 'full_name'.tr,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          profileController,
                          'Card Number',
                          profileController.cardNumber.value,
                          () => profileController.editField('Card Number'),
                          hasEditIcon: true,
                          translatedLabel: 'card_number'.tr,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          profileController,
                          'Mobile Number',
                          profileController.mobileNumber.value,
                          () => profileController.editField('Mobile Number'),
                          hasEditIcon: true,
                          translatedLabel: 'mobile_number'.tr,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(15)),
                      Obx(
                        () => _buildProfileField(
                          profileController,
                          'Birth Date',
                          profileController.birthDate.value,
                          () => profileController.editField('Birth Date'),
                          hasEditIcon: true,
                          translatedLabel: 'birth_date'.tr,
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
                            border: Border.all(
                              color: Colors.orange,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // EN Side
                              Container(
                                width: 50,
                                height: 35,
                                decoration: BoxDecoration(
                                  color:
                                      isEnglish ? Colors.orange : Colors.black,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(30),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    color:
                                        isEnglish
                                            ? Colors.white
                                            : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // JP Side
                              Container(
                                width: 50,
                                height: 35,
                                decoration: BoxDecoration(
                                  color:
                                      !isEnglish ? Colors.orange : Colors.black,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(30),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'JP',
                                  style: TextStyle(
                                    color:
                                        !isEnglish
                                            ? Colors.white
                                            : Colors.orange,
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
                SizedBox(height: ResponsiveSize.height(45)),
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
                        backgroundColor: Color(0xFF227522),
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
                                transform: Matrix4.identity()..scale(1.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 7.0,
                                    right: 9,
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
                          'about'.tr,
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
    ProfileController controller,
    String label,
    String value,
    Function()? onEdit, {
    bool hasEditIcon = true,
    String? translatedLabel,
  }) {
    return Obx(() {
      bool isEditing =
          controller.isEditingField.value &&
          controller.currentlyEditingField.value == label;

      print(
        'Field: $label, isEditing: $isEditing, currentlyEditingField: ${controller.currentlyEditingField.value}',
      );

      TextEditingController? textController;
      if (isEditing) {
        print('Setting up controller for $label');
        switch (label) {
          case 'Full Name':
            textController = controller.nameController;
            break;
          case 'Mobile Number':
            textController = controller.mobileController;
            break;
          case 'Birth Date':
            textController = controller.dobController;
            break;
          case 'Card Number':
            textController = controller.cardNumberController;
            break;
        }
      }

      return Container(
        height:
            isEditing ? ResponsiveSize.height(70) : ResponsiveSize.height(50),
        padding: ResponsiveSize.padding(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translatedLabel ?? label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveSize.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child:
                  isEditing && textController != null
                      ? TextField(
                        controller: textController,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(13),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter $label',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: ResponsiveSize.fontSize(13),
                          ),
                        ),
                        keyboardType:
                            label == 'Mobile Number'
                                ? TextInputType.phone
                                : label == 'Birth Date'
                                ? TextInputType.datetime
                                : label == 'Card Number'
                                ? TextInputType.number
                                : TextInputType.text,
                        autofocus: true,
                      )
                      : Text(
                        value,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(13),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
            ),
            if (isEditing) ...[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: ResponsiveSize.width(22),
                ),
                onPressed: () => controller.saveField(label),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: ResponsiveSize.width(22),
                ),
                onPressed: () => controller.cancelEditing(),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ] else if (hasEditIcon) ...[
              SizedBox(width: ResponsiveSize.width(10)),
              InkWell(
                onTap: onEdit,
                child: Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: ResponsiveSize.width(22),
                ),
              ),
            ],
          ],
        ),
      );
    });
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

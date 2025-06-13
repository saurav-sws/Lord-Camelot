import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/about_points_controller.dart';
import '../../../../services/storage_service.dart';

class AboutPointsView extends GetView<AboutPointsController> {
  const AboutPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aboutPointsController = Get.put(AboutPointsController());
    final storageService = Get.find<StorageService>();

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
        child: Padding(
          padding: ResponsiveSize.padding(vertical: 16, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: ResponsiveSize.height(80),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'about'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Container(
                padding: ResponsiveSize.padding(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        String cardNumber = storageService.cardNumber;

                        return Text(
                          'card_number'.tr + ' $cardNumber',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSize.fontSize(13),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                    SizedBox(width: ResponsiveSize.width(8)),
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/profile'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF288c25)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(20),
                          ),
                        ),
                        minimumSize: Size(
                          ResponsiveSize.width(50),
                          ResponsiveSize.height(40),
                        ),
                      ),
                      child: Text(
                        'my_profile'.tr,
                        style: TextStyle(
                          color: Color(0xFF288c25),
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
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            'about_program'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "■ ",
                              style: TextStyle(color: Color(0xFF288c25)),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                'earn_point'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "■ ",
                              style: TextStyle(color: Color(0xFF288c25)),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                'purchase_recorded'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "■ ",
                              style: TextStyle(color: Color(0xFF288c25)),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                'points_expire'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(
                          "reach_points".tr,
                          style: TextStyle(color: Colors.orange),
                        ),
                        SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPointsRow("¥50,000 – ¥99,999", "¥2,000 discount Or Gift"),
                            SizedBox(height: 8),
                            _buildPointsRow("¥100,000 – ¥199,999", "¥5,000 discount Or Gift"),
                            SizedBox(height: 8),
                            _buildPointsRow("¥200,000+", "¥10,000 discount Or Gift"),
                          ],
                        ),
                        SizedBox(height: 16),
                        Transform(
                          transform: Matrix4.identity()..scale( 1.0),
                          child: Text(
                            'tracking_info'.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPointsRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white70,
            ),
          ),
        ),
        Text(
          "= $right",
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

}

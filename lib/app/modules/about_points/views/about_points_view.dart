import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/about_points_controller.dart';

class AboutPointsView extends GetView<AboutPointsController> {
  const AboutPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aboutPointsController = Get.put(AboutPointsController());

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
          padding: ResponsiveSize.padding(vertical: 16, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: ResponsiveSize.height(80),
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'about_points'.tr,
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
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'card_number'.tr + ' 678543',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                          ResponsiveSize.width(100),
                          ResponsiveSize.height(45),
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
                      color: Color(0xFF0f0f0f),
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

                        // Improved layout for the points range information
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(5),
                          },
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "¥50,000 – ¥99,999",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Text(
                                  "= ¥2,000 discount Or Gift",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "¥100,000 – ¥199,999",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Text(
                                  "= ¥5,000 discount Or Gift",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "¥200,000+",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Text(
                                  "= ¥10,000 discount Or Gift",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16),
                        Text(
                          'tracking_start'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'before_date'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white70,
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
}

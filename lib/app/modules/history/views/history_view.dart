import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    return Scaffold(
      backgroundColor: Colors.black,
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
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                height: ResponsiveSize.height(70),
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    'history'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'card_number'.tr + ' ${historyController.cardNumber}',
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
                      onPressed: historyController.goToProfile,
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
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Padding(
                  padding: ResponsiveSize.padding(horizontal: 17, vertical: 14),
                  child: Text(
                    'points_history'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: historyController.historyEntries.length,
                    itemBuilder: (context, index) {
                      final entry = historyController.historyEntries[index];
                      return Container(
                        margin: ResponsiveSize.margin(bottom: 16),
                        padding: ResponsiveSize.padding(all: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF0f0f0f),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: ResponsiveSize.width(20),
                              children: [
                                Text(
                                  'date'.tr + ' ${entry.date}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: ResponsiveSize.fontSize(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'card_number'.tr + ' ${entry.cardNumber}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: ResponsiveSize.fontSize(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.height(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'total_points'.tr,
                                    style: TextStyle(
                                      color: const Color(0xFFb59345),
                                      fontSize: ResponsiveSize.fontSize(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${entry.totalPoints}',
                                  style: TextStyle(
                                    color: const Color(0xFFb59345),
                                    fontSize: ResponsiveSize.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.height(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'total_amount'.tr,
                                    style: TextStyle(
                                      color: const Color(0xFFb59345),
                                      fontSize: ResponsiveSize.fontSize(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  entry.totalAmount,
                                  style: TextStyle(
                                    color: const Color(0xFFb59345),
                                    fontSize: ResponsiveSize.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.height(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'total_discount'.tr,
                                    style: TextStyle(
                                      color: const Color(0xFFb59345),
                                      fontSize: ResponsiveSize.fontSize(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  entry.totalDiscount,
                                  style: TextStyle(
                                    color: const Color(0xFFb59345),
                                    fontSize: ResponsiveSize.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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

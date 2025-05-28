import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/my_points_controller.dart';

class MyPointsView extends GetView<MyPointsController> {
  const MyPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myPointsController = Get.put(MyPointsController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF000000), Color(0xFF001e16)],
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: ResponsiveSize.padding(vertical: 16, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveSize.height(60)),
              Container(
                width: double.infinity,
                height: ResponsiveSize.height(80),

                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    'my_points'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(20)),

              Container(
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'card_number'.tr + ' ${myPointsController.cardNumber}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveSize.fontSize(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: myPointsController.goToProfile,
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
                          fontSize: ResponsiveSize.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.height(20)),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: myPointsController.pointEntries.length,
                    itemBuilder: (context, index) {
                      final entry = myPointsController.pointEntries[index];
                      return Container(
                        margin: ResponsiveSize.margin(bottom: 16),
                        padding: ResponsiveSize.padding(all: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(10),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildEntryField(
                                    'dealer_number'.tr,
                                    entry.dealerNumber,
                                  ),
                                  SizedBox(height: ResponsiveSize.height(6)),
                                  _buildEntryField('date'.tr, entry.date),
                                  SizedBox(height: ResponsiveSize.height(6)),
                                  _buildEntryField(
                                    'item_code'.tr,
                                    entry.itemCode,
                                  ),
                                  SizedBox(height: ResponsiveSize.height(6)),
                                  _buildEntryField(
                                    'total'.tr,
                                    entry.total.toString(),
                                  ),
                                  SizedBox(height: ResponsiveSize.height(6)),
                                  _buildEntryField(
                                    'point_receive'.tr,
                                    entry.pointReceive,
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'point_redeemed'.tr,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: ResponsiveSize.fontSize(13),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Container(
                                      width: ResponsiveSize.width(15),
                                      height: ResponsiveSize.height(15),
                                      decoration: BoxDecoration(
                                        color:
                                            entry.isRedeemed
                                                ? Color(0xFF288c25)
                                                : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Date :${entry.redemptionDate}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: ResponsiveSize.fontSize(13),
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

  Widget _buildEntryField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveSize.fontSize(13),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(5)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

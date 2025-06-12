import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';

import '../controllers/redeem_points_controller.dart';

class RedeemPointsView extends GetView<RedeemPointsController> {
  const RedeemPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final redeemController = Get.put(RedeemPointsController());
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

            children: [
              SizedBox(height: 30),
              Container(
                height: ResponsiveSize.height(80),
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()..scale( 1.1),
                    child: Text(
                      'redeem_points'.tr,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveSize.fontSize(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: ResponsiveSize.padding(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF0f0f0f),
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform(
                      transform: Matrix4.identity()..scale( 1.1),
                      child: Text(
                        'card_number'.tr + ' ${redeemController.cardNumber}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: redeemController.goToProfile,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF288c25)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(20),
                          ),
                        ),
                        minimumSize: Size(
                          ResponsiveSize.width(90),
                          ResponsiveSize.height(50),
                        ),
                      ),
                      child: Transform(
                        transform: Matrix4.identity()..scale( 1.1),
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

              SizedBox(height: ResponsiveSize.height(16)),
              Row(
                children: [
                  Transform(
                    transform: Matrix4.identity()..scale( 1.1),
                    child: Text(
                      'redeem_minimum'.tr.replaceFirst(
                        '5',
                        '${redeemController.minimumPoints}',
                      ),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveSize.fontSize(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(8)),
                  Obx(
                    () => Text(
                      '${redeemController.availablePoints.value}',
                      style: TextStyle(
                        color:  Color(0xFF227522),
                        fontSize: ResponsiveSize.fontSize(25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: redeemController.dealerEntries.length,
                    itemBuilder: (context, index) {
                      final entry = redeemController.dealerEntries[index];
                      return Container(
                        margin: ResponsiveSize.margin(bottom: 12),
                        padding: ResponsiveSize.padding(all: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF0f0f0f),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildEntryField(
                                    label: 'dealer_number'.tr,
                                    value: entry.dealerNumber,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              dealerNumber: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'date'.tr,
                                    value: entry.date,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              date: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'item_code'.tr,
                                    value: entry.itemCode,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              itemCode: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'total'.tr,
                                    value: entry.total,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              total: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'point_receive'.tr,
                                    value: entry.pointsReceive,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              pointsReceive: value,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'redeeme'.tr,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: ResponsiveSize.fontSize(12),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap:
                                          () => redeemController.toggleRedeemed(
                                            index,
                                          ),
                                      child: Container(
                                        width: ResponsiveSize.width(24),
                                        height: ResponsiveSize.height(24),
                                        decoration: BoxDecoration(
                                          color:
                                              entry.isRedeemed
                                                  ? Color(0xFF288c25)
                                                  : Colors.transparent,
                                          border: Border.all(
                                            color:
                                                entry.isRedeemed
                                                    ? Color(0xFF288c25)
                                                    : Colors.grey,
                                            width: 1.5,
                                          ),
                                        ),
                                        child:
                                            entry.isRedeemed
                                                ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                )
                                                : null,
                                      ),
                                    ),
                                  ],
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

  Widget _buildEntryField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: ResponsiveSize.padding(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

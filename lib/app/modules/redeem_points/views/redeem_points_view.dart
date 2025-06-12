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
                    transform: Matrix4.identity()..scale(1.1),
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
                      transform: Matrix4.identity()..scale(1.1),
                      child: Obx(
                        () => Text(
                          'card_number'.tr +
                              ' ${redeemController.cardNumber.value}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSize.fontSize(14),
                            fontWeight: FontWeight.w500,
                          ),
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
                        transform: Matrix4.identity()..scale(1.1),
                        child: Text(
                          'my_profile'.tr,
                          style: TextStyle(
                            color: Color(0xFF227522),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Transform(
                    transform: Matrix4.identity()..scale(1.1),
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

                  Obx(
                    () => Transform(
                      transform: Matrix4.identity()..scale(1.1),
                      child: Text(
                        '${redeemController.availablePoints.value}',
                        style: TextStyle(
                          color: Color(0xFF227522),
                          fontSize: ResponsiveSize.fontSize(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              Expanded(
                child: Obx(() {
                  if (redeemController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  if (redeemController.pointHistoryList.isEmpty) {
                    return Center(
                      child: Text(
                        'No point history available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(16),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: redeemController.refreshData,
                    child: ListView.builder(
                      itemCount: redeemController.pointHistoryList.length,
                      itemBuilder: (context, index) {
                        final pointHistory =
                            redeemController.pointHistoryList[index];
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
                                    _buildInfoRow(
                                      'dealer_number'.tr,
                                      pointHistory.dealerNumber,
                                    ),
                                    _buildInfoRow(
                                      'date'.tr,
                                      pointHistory.formattedPurchaseDate,
                                    ),
                                    _buildInfoRow(
                                      'item_code'.tr,
                                      pointHistory.itemCode,
                                    ),
                                    _buildInfoRow(
                                      'total'.tr,
                                      pointHistory.formattedTotal,
                                    ),
                                    _buildInfoRow(
                                      'point_receive'.tr,
                                      '${pointHistory.point}',
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pointHistory.isAlreadyRedeemed
                                        ? 'Redeemed'
                                        : 'redeeme'.tr,
                                    style: TextStyle(
                                      color:
                                          pointHistory.isAlreadyRedeemed
                                              ? Colors.orange
                                              : Colors.white70,
                                      fontSize: ResponsiveSize.fontSize(12),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap:
                                        pointHistory.isAlreadyRedeemed
                                            ? null
                                            : () => redeemController
                                                .togglePointSelection(index),
                                    child: Container(
                                      width: ResponsiveSize.width(24),
                                      height: ResponsiveSize.height(24),
                                      decoration: BoxDecoration(
                                        color:
                                            pointHistory.isAlreadyRedeemed
                                                ? Colors.orange
                                                : pointHistory.isSelected
                                                ? Color(0xFF288c25)
                                                : Colors.transparent,
                                        border: Border.all(
                                          color:
                                              pointHistory.isAlreadyRedeemed
                                                  ? Colors.orange
                                                  : pointHistory.isSelected
                                                  ? Color(0xFF288c25)
                                                  : Colors.grey,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),


              Obx(() {
                if (!redeemController.hasSelectedPoints) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: ResponsiveSize.margin(vertical: 10),
                  padding: ResponsiveSize.padding(all: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF0f0f0f),
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveSize.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Points:',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${redeemController.totalSelectedPoints.value}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '¥${redeemController.totalAmount.value.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Discount:',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '¥${redeemController.totalDiscount.value.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),


              Obx(() {
                if (!redeemController.hasSelectedPoints) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  height: ResponsiveSize.height(50),
                  margin: ResponsiveSize.margin(vertical: 10),
                  child: ElevatedButton(
                    onPressed:
                        redeemController.canRedeem &&
                                !redeemController.isLoadingRedeem.value
                            ? redeemController.redeemSelectedPoints
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          redeemController.canRedeem
                              ? Color(0xFF288c25)
                              : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.radius(10),
                        ),
                      ),
                    ),
                    child:
                        redeemController.isLoadingRedeem.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Redeem Points',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.fontSize(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(

      children: [
        SizedBox(
          width: ResponsiveSize.width(120),
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveSize.fontSize(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';

import '../controllers/redeem_points_controller.dart';

class RedeemPointsView extends StatefulWidget {
  const RedeemPointsView({Key? key}) : super(key: key);

  @override
  State<RedeemPointsView> createState() => _RedeemPointsViewState();
}

class _RedeemPointsViewState extends State<RedeemPointsView>
    with WidgetsBindingObserver {
  late RedeemPointsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RedeemPointsController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app is resumed
      controller.refreshData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be called when the route is pushed or popped
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent == true) {
        // This view is now the current view, refresh data
        controller.onResume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black54,
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
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform(
                      transform: Matrix4.identity()..scale(1.0),
                      child: Obx(
                        () => Text(
                          'card_number'.tr + ' ${controller.cardNumber.value}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSize.fontSize(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: controller.goToProfile,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Transform(
                      transform: Matrix4.identity()..scale(1.1),
                      child: Row(
                        children: [
                          Text(
                            'redeem_minimum'.tr.replaceFirst(
                              '5',
                              '${controller.minimumPoints}',
                            ),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(13),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                              right: 40,
                            ),
                            child: Transform(
                              transform: Matrix4.identity()..scale(1.1),
                              child: Text(
                                ' ${controller.totalSelectedPoints.value}',
                                style: TextStyle(
                                  color: Color(0xFF227522),
                                  fontSize: ResponsiveSize.fontSize(22),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  final unredeemedPoints =
                      controller.pointHistoryList
                          .where((point) => !point.isAlreadyRedeemed)
                          .toList();

                  if (unredeemedPoints.isEmpty) {
                    return Center(
                      child: Text(
                        'No unredeemed points available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(16),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshData,
                    child: ListView.builder(
                      itemCount: unredeemedPoints.length,
                      itemBuilder: (context, index) {
                        final pointHistory = unredeemedPoints[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'redeeme'.tr,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: ResponsiveSize.fontSize(12),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap:
                                        () => controller.togglePointSelection(
                                          controller.pointHistoryList.indexOf(
                                            pointHistory,
                                          ),
                                        ),
                                    child: Container(
                                      width: ResponsiveSize.width(24),
                                      height: ResponsiveSize.height(24),
                                      decoration: BoxDecoration(
                                        color:
                                            pointHistory.isSelected
                                                ? Color(0xFF288c25)
                                                : Colors.black,
                                        border: Border.all(
                                          color: Color(0xFF288c25),
                                          width: 1.5,
                                        ),
                                      ),
                                      child:
                                          pointHistory.isSelected
                                              ? Icon(
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
                        );
                      },
                    ),
                  );
                }),
              ),

              Obx(() {
                if (!controller.hasSelectedPoints) {
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
                        '${'summary'.tr} (${controller.totalSelectedPoints.value} ${'my_points'.tr})',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveSize.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Discount explanation
                      Container(
                        padding: ResponsiveSize.padding(all: 8),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'discount_tier1'.tr,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: ResponsiveSize.fontSize(12),
                              ),
                            ),
                            Text(
                              'discount_tier2'.tr,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: ResponsiveSize.fontSize(12),
                              ),
                            ),
                            Text(
                              'discount_tier3'.tr,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: ResponsiveSize.fontSize(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_points'.tr,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${controller.totalSelectedPoints.value}',
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
                            'total_amount'.tr,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '¥${controller.totalAmount.value.toStringAsFixed(0)}',
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
                            'total_discount'.tr,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '¥${controller.totalDiscount.value.toStringAsFixed(0)}',
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
                if (!controller.hasSelectedPoints) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  height: ResponsiveSize.height(50),
                  margin: ResponsiveSize.margin(vertical: 10),
                  child: ElevatedButton(
                    onPressed:
                        controller.canRedeem &&
                                !controller.isLoadingRedeem.value
                            ? controller.redeemSelectedPoints
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.canRedeem
                              ? Color(0xFF288c25)
                              : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.radius(10),
                        ),
                      ),
                    ),
                    child:
                        controller.isLoadingRedeem.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              '${'redeeme'.tr} ${controller.totalSelectedPoints.value} ${'my_points'.tr}',
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
          child: Transform(
            transform: Matrix4.identity()..scale(1.1),
            child: Text(
              '$label',
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveSize.fontSize(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: Transform(
            transform: Matrix4.identity()..scale(1.1),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveSize.fontSize(12),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

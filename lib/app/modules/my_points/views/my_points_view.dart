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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'my_points'.tr,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveSize.fontSize(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(10)),
                    Obx(
                      () =>
                          myPointsController.isLoading.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
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
                    Obx(
                      () => Text(
                        'card_number'.tr +
                            ' ${myPointsController.cardNumber.value}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
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
                child: Obx(() {
                  if (myPointsController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  }

                  if (myPointsController.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          Text(
                            myPointsController.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(14),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          ElevatedButton(
                            onPressed: myPointsController.fetchPoints,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF288c25),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (myPointsController.pointRecords.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                            size: 48,
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          Text(
                            'No points records found',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: myPointsController.refreshPoints,
                    child: ListView.builder(
                      itemCount: myPointsController.pointRecords.length,
                      itemBuilder: (context, index) {
                        final record = myPointsController.pointRecords[index];
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
                              // Left side - Point information
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEntryField(
                                      'dealer_number'.tr,
                                      record.dealerNumber,
                                    ),
                                    SizedBox(height: ResponsiveSize.height(6)),
                                    _buildEntryField(
                                      'date'.tr,
                                      _formatDateTime(record.date),
                                    ),
                                    SizedBox(height: ResponsiveSize.height(6)),
                                    _buildEntryField(
                                      'item_code'.tr,
                                      record.itemCode,
                                    ),
                                    SizedBox(height: ResponsiveSize.height(6)),
                                    _buildEntryField(
                                      'total'.tr,
                                      record.total.toString(),
                                    ),
                                    SizedBox(height: ResponsiveSize.height(6)),
                                    _buildEntryField(
                                      'point_receive'.tr,
                                      record.pointReceive,
                                    ),
                                  ],
                                ),
                              ),


                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                SizedBox(
                              height: ResponsiveSize.height(78)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'point_redeemed'.tr,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: ResponsiveSize.fontSize(
                                            13,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: ResponsiveSize.width(8),
                                      ),
                                      Container(
                                        width: ResponsiveSize.width(15),
                                        height: ResponsiveSize.height(15),
                                        decoration: BoxDecoration(
                                          color:
                                              record.isRedeemed
                                                  ? Color(0xFF288c25)
                                                  : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ResponsiveSize.height(6)),
                                  Text(
                                    'Date: ${record.isRedeemed && record.redemptionDate != null ? _formatDateTime(record.redemptionDate!) : ''}',
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
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryField(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveSize.fontSize(13),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(5)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveSize.fontSize(13),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return 'N/A';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}

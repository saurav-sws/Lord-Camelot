import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/my_points_controller.dart';

class MyPointsView extends StatefulWidget {
  const MyPointsView({Key? key}) : super(key: key);

  @override
  State<MyPointsView> createState() => _MyPointsViewState();
}

class _MyPointsViewState extends State<MyPointsView> {
  late MyPointsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyPointsController());
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
    final myPointsController = controller;

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
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                width: double.infinity,
                height: ResponsiveSize.height(80),
                decoration: BoxDecoration(
                  color: Colors.black54,
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
              SizedBox(height: ResponsiveSize.height(30)),

              Container(
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform(
                      transform: Matrix4.identity()..scale(1.0),
                      child: Obx(
                        () => Text(
                          'card_number'.tr +
                              ' ${myPointsController.cardNumber.value}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSize.fontSize(13),
                            fontWeight: FontWeight.w600,
                          ),
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
                            'no points'.tr,
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
                            color: Color(0xFF0f0f0f),
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
                                  SizedBox(height: ResponsiveSize.height(78)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'point_redeemed'.tr,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: ResponsiveSize.fontSize(12),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.width(8)),
                                      Container(
                                        width: ResponsiveSize.width(12),
                                        height: ResponsiveSize.height(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              record.isRedeemed
                                                  ? Color(0xFF288c25)
                                                  : Colors.red,
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
        Transform(
          transform: Matrix4.identity()..scale(1.1),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(15)),
        Transform(
          transform: Matrix4.identity()..scale(1.1),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveSize.fontSize(12),
              fontWeight: FontWeight.w500,
            ),
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

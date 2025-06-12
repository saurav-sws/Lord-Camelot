import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/history_controller.dart';
import '../../../../services/storage_service.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    final storageService = Get.find<StorageService>();

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
                      child: Obx(() {
                        String cardNumber = storageService.cardNumber;

                        // If no card number from storage, try to get from first history record
                        if (cardNumber.isEmpty &&
                            historyController.redeemHistory.isNotEmpty) {
                          cardNumber =
                              historyController.redeemHistory.first.cardNumber;
                        }

                        // Final fallback to default
                        if (cardNumber.isEmpty) {
                          cardNumber = '678543';
                        }

                        return Text(
                          'card_number'.tr + ' $cardNumber',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveSize.fontSize(14),
                            fontWeight: FontWeight.w500,
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
                height: 50,
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
                child: Obx(() {
                  if (historyController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  }

                  if (historyController.hasError.value) {
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
                            historyController.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(14),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          ElevatedButton(
                            onPressed: historyController.fetchRedeemHistory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF288c25),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (historyController.redeemHistory.isEmpty) {
                    return _buildSampleHistoryData();
                  }

                  return RefreshIndicator(
                    onRefresh: historyController.refreshHistory,
                    child: ListView.builder(
                      itemCount: historyController.redeemHistory.length,
                      itemBuilder: (context, index) {
                        final record = historyController.redeemHistory[index];
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
                                    'date'.tr + ' ${record.formattedDate}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: ResponsiveSize.fontSize(14),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'card_number'.tr + ' ${record.cardNumber}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    record.totalPoint.toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    record.formattedTotalAmount,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    record.formattedDiscount,
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
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSampleHistoryData() {
    return ListView(
      children: [
        _buildHistoryEntry('2024.05.25', '678543', '5', '¥123,000', '¥10,000'),
        _buildHistoryEntry('2025.07.20', '678543', '5', '¥123,000', '¥10,000'),
      ],
    );
  }

  Widget _buildHistoryEntry(
    String date,
    String cardNumber,
    String points,
    String amount,
    String discount,
  ) {
    return Container(
      margin: ResponsiveSize.margin(bottom: 16),
      padding: ResponsiveSize.padding(all: 16),
      decoration: BoxDecoration(
        color: Color(0xFF0f0f0f),
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: ResponsiveSize.width(20),
            children: [
              Text(
                'date'.tr + ' $date',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: ResponsiveSize.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'card_number'.tr + ' $cardNumber',
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
                points,
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
                amount,
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
                discount,
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
  }
}

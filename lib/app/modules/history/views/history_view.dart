import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/history_controller.dart';
import '../../../../services/storage_service.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late HistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HistoryController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent == true) {

        controller.onResume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyController = controller;
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
            children: [
              SizedBox(height: ResponsiveSize.height(30)),
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
                      'history'.tr,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveSize.fontSize(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                    Expanded(
                      child: Obx(() {
                        final storageService = Get.find<StorageService>();
                        String cardNumber =
                            storageService.currentUser.value?.cardNumber ?? '';

                        if (cardNumber.isEmpty) {
                          cardNumber = storageService.cardNumber;
                        }

                        if (cardNumber.isEmpty &&
                            historyController.redeemHistory.isNotEmpty) {
                          cardNumber =
                              historyController.redeemHistory.first.cardNumber;
                        }

                        if (cardNumber.isEmpty) {
                          cardNumber = '678543';
                        }

                        return Transform(
                          transform: Matrix4.identity()..scale(1.1),
                          child: Text(
                            'card_number'.tr + ' $cardNumber',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(13),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: ResponsiveSize.width(8)),
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/profile'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF237220)),
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
                            color:  Color(0xFF237220),
                            fontSize: ResponsiveSize.fontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                height: ResponsiveSize.height(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
                ),
                child: Padding(
                  padding: ResponsiveSize.padding(horizontal: 17, vertical: 14),
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.1),
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
                                  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

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

  Widget _buildCardNumberDisplay() {
    final storageService = Get.find<StorageService>();
    final controller = Get.find<HistoryController>();

    return Obx(() {
      String cardNumber = storageService.currentUser.value?.cardNumber ?? '';

      if (cardNumber.isEmpty) {
        cardNumber = storageService.cardNumber;
      }

      if (cardNumber.isEmpty && controller.redeemHistory.isNotEmpty) {
        cardNumber = controller.redeemHistory.first.cardNumber;
      }

      if (cardNumber.isEmpty) {
        cardNumber = '678543';
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'card_number'.tr + ' $cardNumber',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
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

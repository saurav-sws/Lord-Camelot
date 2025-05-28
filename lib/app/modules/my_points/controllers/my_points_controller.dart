import 'package:get/get.dart';


class MyPointsController extends GetxController {
  final String cardNumber = '678543';

  final RxList<PointEntry> pointEntries = <PointEntry>[].obs;

  int get totalPoints {
    int total = 0;
    for (var entry in pointEntries) {
      if (!entry.isRedeemed) {
        total += int.tryParse(entry.pointReceive) ?? 0;
      }
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();

    pointEntries.addAll([
      PointEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointReceive: '',
        isRedeemed: true,
        redemptionDate: '',
      ),
      PointEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointReceive: '',
        isRedeemed: false,
        redemptionDate: '',
      ),
      PointEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointReceive: '',
        isRedeemed: false,
        redemptionDate: '',
      ),
    ]);
  }

  void goToProfile() {
    Get.toNamed('/profile');
  }
}

class PointEntry {
  final String dealerNumber;
  final String date;
  final String itemCode;
  final String total;
  final String pointReceive;
  final bool isRedeemed;
  final String redemptionDate;

  PointEntry({
    required this.dealerNumber,
    required this.date,
    required this.itemCode,
    required this.total,
    required this.pointReceive,
    required this.isRedeemed,
    required this.redemptionDate,
  });
}

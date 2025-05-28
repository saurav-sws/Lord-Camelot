import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';

class RedeemPointsController extends GetxController {
  final String cardNumber = '678543';
  final int minimumPoints = 5;
  final RxInt availablePoints = 2.obs;

  final RxList<DealerEntry> dealerEntries = <DealerEntry>[].obs;

  @override
  void onInit() {
    super.onInit();

    dealerEntries.addAll([
      DealerEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointsReceive: '',
        isRedeemed: true,
      ),
      DealerEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointsReceive: '',
        isRedeemed: true,
      ),
    ]);
  }

  void goToProfile() {
    Get.toNamed('/profile');
  }

  void toggleRedeemed(int index) {
    if (index < dealerEntries.length) {
      final entry = dealerEntries[index];
      if (entry.dealerNumber.isEmpty ||
          entry.date.isEmpty ||
          entry.itemCode.isEmpty ||
          entry.total.isEmpty ||
          entry.pointsReceive.isEmpty) {
        DialogHelper.showErrorDialog(
          title: 'Incomplete Information',
          message: 'Please fill all fields before redeeming',
        );
        return;
      }

      dealerEntries[index] = entry.copyWith(isRedeemed: !entry.isRedeemed);
    }
  }

  void updateDealerEntry(
    int index, {
    String? dealerNumber,
    String? date,
    String? itemCode,
    String? total,
    String? pointsReceive,
  }) {
    if (index < dealerEntries.length) {
      final entry = dealerEntries[index];
      dealerEntries[index] = entry.copyWith(
        dealerNumber: dealerNumber ?? entry.dealerNumber,
        date: date ?? entry.date,
        itemCode: itemCode ?? entry.itemCode,
        total: total ?? entry.total,
        pointsReceive: pointsReceive ?? entry.pointsReceive,
      );
    }
  }
}

class DealerEntry {
  final String dealerNumber;
  final String date;
  final String itemCode;
  final String total;
  final String pointsReceive;
  final bool isRedeemed;

  DealerEntry({
    required this.dealerNumber,
    required this.date,
    required this.itemCode,
    required this.total,
    required this.pointsReceive,
    required this.isRedeemed,
  });

  DealerEntry copyWith({
    String? dealerNumber,
    String? date,
    String? itemCode,
    String? total,
    String? pointsReceive,
    bool? isRedeemed,
  }) {
    return DealerEntry(
      dealerNumber: dealerNumber ?? this.dealerNumber,
      date: date ?? this.date,
      itemCode: itemCode ?? this.itemCode,
      total: total ?? this.total,
      pointsReceive: pointsReceive ?? this.pointsReceive,
      isRedeemed: isRedeemed ?? this.isRedeemed,
    );
  }
}

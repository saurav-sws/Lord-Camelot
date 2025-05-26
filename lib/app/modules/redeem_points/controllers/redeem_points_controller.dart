import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';

class RedeemPointsController extends GetxController {
  // Card number
  final String cardNumber = '678543';

  // Minimum points required
  final int minimumPoints = 5;

  // Current points available to redeem
  final RxInt availablePoints = 2.obs;

  // List of dealer entries (observable)
  final RxList<DealerEntry> dealerEntries = <DealerEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with three dealer entries
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
      DealerEntry(
        dealerNumber: '',
        date: '',
        itemCode: '',
        total: '',
        pointsReceive: '',
        isRedeemed: false,
      ),
    ]);
  }

  // Navigate to profile page
  void goToProfile() {
    DialogHelper.showInfoDialog(
      title: 'Profile',
      message: 'Profile functionality will be available soon',
    );
  }

  // Toggle the redeemed status
  void toggleRedeemed(int index) {
    if (index < dealerEntries.length) {
      final entry = dealerEntries[index];

      // Only allow redemption if we have filled all fields
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

      // Toggle the status
      dealerEntries[index] = entry.copyWith(isRedeemed: !entry.isRedeemed);
    }
  }

  // Update dealer entry fields
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

// Model class for dealer entries
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

  // Create a copy with some changes
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

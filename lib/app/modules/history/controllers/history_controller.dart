import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';

class HistoryController extends GetxController {
  // Card number
  final String cardNumber = '678543';

  // History entries
  final RxList<HistoryEntry> historyEntries = <HistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample history data
    historyEntries.addAll([
      HistoryEntry(
        date: '2024.05.25',
        cardNumber: '678543',
        totalPoints: 5,
        totalAmount: '¥123,000',
        totalDiscount: '¥10,000',
      ),
      HistoryEntry(
        date: '2025.07.20',
        cardNumber: '678543',
        totalPoints: 5,
        totalAmount: '¥123,000',
        totalDiscount: '¥10,000',
      ),
    ]);
  }

  // Navigate to profile page
  void goToProfile() {
    Get.toNamed('/profile');
  }
}

// Model class for history entries
class HistoryEntry {
  final String date;
  final String cardNumber;
  final int totalPoints;
  final String totalAmount;
  final String totalDiscount;

  HistoryEntry({
    required this.date,
    required this.cardNumber,
    required this.totalPoints,
    required this.totalAmount,
    required this.totalDiscount,
  });
}

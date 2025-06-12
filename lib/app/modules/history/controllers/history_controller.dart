import 'package:get/get.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';
import '../../../models/redeem_history_model.dart';

class HistoryController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<RedeemHistory> redeemHistory = <RedeemHistory>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRedeemHistory();
  }

  Future<void> fetchRedeemHistory() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Check if user is logged in
      if (!_storageService.hasUser) {
        hasError.value = true;
        errorMessage.value =
            'You are not logged in. Please login to view your redemption history.';
        isLoading.value = false;
        return;
      }

      print('Fetching redeem history from API...');
      final response = await _apiService.getRedeemHistory();

      if (response['success'] == true) {
        final List<dynamic> historyData = response['redeem_history'] ?? [];
        final records =
            historyData.map((data) => RedeemHistory.fromJson(data)).toList();

        redeemHistory.value = records;

        print('Fetched ${redeemHistory.length} redeem history records');
        for (var record in redeemHistory) {
          print(
            'Record: ID=${record.id}, Points=${record.totalPoint}, Amount=${record.totalAmount}, Discount=${record.discount}, Card=${record.cardNumber}',
          );
        }
      } else {
        hasError.value = true;
        errorMessage.value =
            response['message'] ?? 'Failed to load redemption history';
        print('API returned success=false: ${response['message']}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching redemption history: $e';
      print('Error fetching redemption history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistory() async {
    // Reset error state
    hasError.value = false;
    errorMessage.value = '';

    // Fetch fresh data
    await fetchRedeemHistory();
    return;
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';

    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}

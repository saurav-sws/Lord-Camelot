import 'package:get/get.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';
import '../../../models/point_record_model.dart';
import '../../../utils/dialog_helper.dart';

class MyPointsController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  final RxString cardNumber = ''.obs;
  final RxList<PointRecord> pointRecords = <PointRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  int get totalPoints {
    int total = 0;
    for (var record in pointRecords) {
      if (!record.isRedeemed) {
        total += int.tryParse(record.pointReceive) ?? 0;
      }
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();

    // Get card number from storage if available
    if (_storageService.currentUser.value != null) {
      // If you have card number stored in user model, you can set it here
      // cardNumber.value = _storageService.currentUser.value!.cardNumber;
    }

    // Fetch points data from API
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Check if user is logged in
      if (!_storageService.hasUser) {
        hasError.value = true;
        errorMessage.value =
            'You are not logged in. Please login to view your points.';
        isLoading.value = false;
        return;
      }

      // Get card number from current user
      // Since the User model doesn't have a cardNumber property,
      // we'll use a default value or retrieve it from another source
      final user = _storageService.currentUser.value;
      cardNumber.value = '678543'; // Default or placeholder value

      final response = await _apiService.getPoints();

      if (response['success'] == true) {
        final List<dynamic> pointsData = response['point_records'] ?? [];
        final records =
            pointsData.map((data) {
              // Add mock redemption data for demo purposes if needed
              // In real app, this would come from the API
              final isRedeemedStatus = data['is_redeemed'] ?? false;
              final redemptionDateValue = data['redemption_date'];

              // Create a modified data map to pass to PointRecord.fromJson
              final Map<String, dynamic> modifiedData = {...data};
              modifiedData['is_redeemed'] = isRedeemedStatus;

              // If it's redeemed but no redemption date, add a sample one for first record
              if (isRedeemedStatus &&
                  redemptionDateValue == null &&
                  pointsData.indexOf(data) == 0) {
                modifiedData['redemption_date'] = '2024-05-25T00:00:00.000000Z';
              }

              return PointRecord.fromJson(modifiedData);
            }).toList();

        pointRecords.value = records;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load points data';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching points: $e';
      print('Error fetching points: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPoints() async {
    // Reset error state
    hasError.value = false;
    errorMessage.value = '';

    // Fetch fresh data
    await fetchPoints();
    return;
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

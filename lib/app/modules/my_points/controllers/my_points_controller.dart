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

    // Use the reactive state from StorageService
    _setupCardNumberListener();

    fetchPoints();
  }

  // This method will be called when the view is resumed (becomes visible again)
  void onResume() {
    print('My Points view resumed - refreshing data');
    refreshPoints();
  }

  void _setupCardNumberListener() {
    // Initial setup
    cardNumber.value = _storageService.cardNumber;

    if (cardNumber.value.isEmpty) {
      cardNumber.value = '678543';
    }

    // Listen for changes to the user in StorageService
    ever(_storageService.currentUser, (user) {
      if (user != null && user.cardNumber.isNotEmpty) {
        cardNumber.value = user.cardNumber;
        print(
          'MyPointsController: Updated card number from StorageService: ${cardNumber.value}',
        );
      }
    });
  }

  Future<void> fetchPoints() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      if (!_storageService.hasUser) {
        hasError.value = true;
        errorMessage.value =
            'You are not logged in. Please login to view your points.';
        isLoading.value = false;
        return;
      }

      final currentCardNumber = _storageService.cardNumber;
      if (currentCardNumber.isNotEmpty) {
        cardNumber.value = currentCardNumber;
      }

      final response = await _apiService.getPointHistory();

      if (response['success'] == true) {
        List<dynamic>? pointsData;

        if (response['data'] != null) {
          pointsData = response['data'];
        } else if (response['point_history'] != null) {
          pointsData = response['point_history'];
        } else if (response['points'] != null) {
          pointsData = response['points'];
        } else {
          pointsData = [];
        }

        final records =
            pointsData!.map((data) {
              return PointRecord.fromJson(data);
            }).toList();

        pointRecords.value = records;

        print('Fetched ${pointRecords.length} point records');
        print('Total unredeemed points: ${totalPoints}');
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
    hasError.value = false;
    errorMessage.value = '';

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/storage_service.dart';
import '../../../../services/api_service.dart';
import '../../../models/point_history_model.dart';

class RedeemPointsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = ApiService();
  final RxString cardNumber = ''.obs;
  final int minimumPoints = 5;
  final RxInt availablePoints = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingRedeem = false.obs;

  final RxList<PointHistory> pointHistoryList = <PointHistory>[].obs;
  final RxList<PointHistory> selectedPoints = <PointHistory>[].obs;

  final RxInt totalSelectedPoints = 0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupCardNumberListener();
    _loadPointHistory();
  }

  @override
  void onReady() {
    super.onReady();
    // Initial load is already done in onInit
  }

  @override
  void onClose() {
    super.onClose();
  }

  // This method will be called when the view is resumed (becomes visible again)
  void onResume() {
    print('Redeem Points view resumed - refreshing data');
    refreshData();
  }

  void _setupCardNumberListener() {
    // Initial setup
    final user = _storageService.currentUser.value;
    if (user != null && user.cardNumber.isNotEmpty) {
      cardNumber.value = user.cardNumber;
    } else {
      cardNumber.value = _storageService.cardNumber;
    }

    // Listen for changes to the user in StorageService
    ever(_storageService.currentUser, (user) {
      if (user != null && user.cardNumber.isNotEmpty) {
        cardNumber.value = user.cardNumber;
        print(
          'RedeemPointsController: Updated card number from StorageService: ${cardNumber.value}',
        );

        // Reload point history when card number changes
        _loadPointHistory();
      }
    });
  }

  Future<void> _loadPointHistory() async {
    try {
      isLoading.value = true;
      print('Loading points data from API...');
      final response = await _apiService.getPoints();

      print('Points API response: $response');

      if (response['success'] == true) {
        List<dynamic>? data;

        if (response['data'] != null) {
          data = response['data'];
          print('Using response[data] key');
        } else if (response['point_records'] != null) {
          data = response['point_records'];
          print('Using response[point_records] key');
        } else if (response['points'] != null) {
          data = response['points'];
          print('Using response[points] key');
        }

        if (data != null && data.isNotEmpty) {
          print('Found ${data.length} point items');
          pointHistoryList.value =
              data.map((item) {
                print('Processing item: $item');

                return PointHistory.fromJson(item);
              }).toList();

          availablePoints.value = pointHistoryList
              .where((point) => !point.isAlreadyRedeemed)
              .fold(0, (sum, point) => sum + point.point);

          print('Loaded ${pointHistoryList.length} point items');
          print('Available unredeemed points: ${availablePoints.value}');

          if (pointHistoryList
              .where((point) => !point.isAlreadyRedeemed)
              .isEmpty) {
            print('No unredeemed points available');
          }
        } else {
          print('No point data found in response');
          pointHistoryList.clear();
          availablePoints.value = 0;
        }
      } else {
        print('API returned success=false: ${response['message']}');
        throw Exception(response['message'] ?? 'Failed to load points data');
      }
    } catch (e) {
      print('Error loading points data: $e');

      // Check if the error is related to authentication
      String errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('unauthenticated') ||
          errorMsg.contains('unauthorized') ||
          errorMsg.contains('token') ||
          errorMsg.contains('not found') ||
          errorMsg.contains('user not exist')) {
        print('Authentication error detected, redirecting to login screen');

        // Clear user data
        await _storageService.clearUser();

        // Navigate to login screen
        Get.offAllNamed('/login');

        return;
      }

      DialogHelper.showErrorDialog(
        title: 'Error',
        message: 'Failed to load points data. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePointSelection(int index) {
    if (index >= pointHistoryList.length) return;

    final pointHistory = pointHistoryList[index];

    if (pointHistory.isAlreadyRedeemed) {
      DialogHelper.showInfoDialog(
        title: 'Already Redeemed',
        message: 'This point has already been redeemed',
      );
      return;
    }

    final updatedPoint = pointHistory.copyWith(
      isSelected: !pointHistory.isSelected,
    );

    pointHistoryList[index] = updatedPoint;

    if (updatedPoint.isSelected) {
      selectedPoints.add(updatedPoint);
    } else {
      selectedPoints.removeWhere((item) => item.id == updatedPoint.id);
    }

    _calculateSummary();
  }

  void _calculateSummary() {
    totalSelectedPoints.value = selectedPoints.fold(
      0,
      (sum, item) => sum + item.point,
    );
    totalAmount.value = selectedPoints.fold(
      0.0,
      (sum, item) => sum + double.parse(item.total),
    );

    if (totalAmount.value >= 50000 && totalAmount.value < 100000) {
      totalDiscount.value = 2000.0;
    } else if (totalAmount.value >= 100000 && totalAmount.value < 200000) {
      totalDiscount.value = 5000.0;
    } else if (totalAmount.value >= 200000) {
      totalDiscount.value = 10000.0;
    } else {
      totalDiscount.value = 0.0;
    }

    print(
      'Summary - Points: ${totalSelectedPoints.value}, Amount: ${totalAmount.value}, Discount: ${totalDiscount.value}',
    );
  }

  bool get canRedeem => totalSelectedPoints.value >= minimumPoints;
  bool get hasSelectedPoints =>
      selectedPoints.isNotEmpty && totalSelectedPoints.value >= minimumPoints;

  Future<void> redeemSelectedPoints() async {
    if (!canRedeem || selectedPoints.isEmpty) return;

    final confirmed = await _showRedeemConfirmation();
    if (!confirmed) return;

    try {
      isLoadingRedeem.value = true;

      final pointIds = selectedPoints.map((point) => point.id).toList();

      final user = _storageService.currentUser.value;
      final userId = user?.userId?.toString() ?? '0';

      print('Redeeming points with data:');
      print('Point IDs: $pointIds');
      print('Total Amount: ${totalAmount.value}');
      print('Discount: ${totalDiscount.value}');
      print('Total Points: ${totalSelectedPoints.value}');
      print('Card Number: ${cardNumber.value}');
      print('User ID: $userId');

      final response = await _apiService.redeemPoints(
        pointIds: pointIds,
        totalAmount: totalAmount.value,
        discount: totalDiscount.value,
        totalPoint: totalSelectedPoints.value,
        cardNumber: cardNumber.value,
        userId: userId,
      );

      print('Redeem API response: $response');

      if (response['success'] == true ||
          response['message']?.contains('successful') == true) {
        for (var selectedPoint in selectedPoints) {
          final index = pointHistoryList.indexWhere(
            (p) => p.id == selectedPoint.id,
          );
          if (index != -1) {
            pointHistoryList[index] = pointHistoryList[index].copyWith(
              isRedeemed: 1,
              redeemDate: DateTime.now().toString().split(' ')[0],
            );
          }
        }

        selectedPoints.clear();
        _calculateSummary();

        availablePoints.value = pointHistoryList
            .where((point) => !point.isAlreadyRedeemed)
            .fold(0, (sum, point) => sum + point.point);

        DialogHelper.showSuccessDialog(
          title: 'success'.tr,
          message: response['message'] ?? 'points_redeemed_success'.tr,
        );

        await _loadPointHistory();
      } else {
        throw Exception(response['message'] ?? 'Failed to redeem points');
      }
    } catch (e) {
      print('Error redeeming points: $e');

      if (!e.toString().toLowerCase().contains('successful')) {
        DialogHelper.showErrorDialog(
          title: 'Error',
          message: 'Failed to redeem points. Please try again.',
        );
      } else {
        DialogHelper.showSuccessDialog(
          title: 'success'.tr,
          message: e.toString().replaceAll('Exception: ', ''),
        );

        await _loadPointHistory();
      }
    } finally {
      isLoadingRedeem.value = false;
    }
  }

  Future<bool> _showRedeemConfirmation() async {
    bool confirmed = false;

    await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('summary'.tr, style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('redeem_minimum'.tr, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text(
              '${'total_points'.tr} ${totalSelectedPoints.value}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${'total_amount'.tr} ¥${totalAmount.value.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              '${'total_discount'.tr} ¥${totalDiscount.value.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmed = false;
              Get.back();
            },
            child: Text('cancel'.tr, style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              confirmed = true;
              Get.back();
            },
            child: Text('redeeme'.tr, style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    return confirmed;
  }

  void goToProfile() {
    Get.toNamed('/profile');
  }

  Future<void> refreshData() async {
    _clearSelections();
    await _loadPointHistory();
  }

  void _clearSelections() {
    for (int i = 0; i < pointHistoryList.length; i++) {
      if (pointHistoryList[i].isSelected) {
        pointHistoryList[i] = pointHistoryList[i].copyWith(isSelected: false);
      }
    }

    selectedPoints.clear();

    totalSelectedPoints.value = 0;
    totalAmount.value = 0.0;
    totalDiscount.value = 0.0;
  }
}

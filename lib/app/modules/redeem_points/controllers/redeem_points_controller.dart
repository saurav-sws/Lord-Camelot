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

  // Summary calculations
  final RxInt totalSelectedPoints = 0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCardNumber();
    _loadPointHistory();
  }

  void _loadCardNumber() {
    final user = _storageService.currentUser.value;
    if (user != null && user.cardNumber.isNotEmpty) {
      cardNumber.value = user.cardNumber;
    } else {
      cardNumber.value = _storageService.cardNumber;
    }

    // Fallback to static value if still empty
    if (cardNumber.value.isEmpty) {
      cardNumber.value = '678543';
    }

    print('RedeemPointsController - Loaded card number: ${cardNumber.value}');
  }

  Future<void> _loadPointHistory() async {
    try {
      isLoading.value = true;
      print('Loading point history from API...');
      final response = await _apiService.getPointHistory();

      print('Point history API response: $response');

      if (response['success'] == true) {
        // Try different possible data keys
        List<dynamic>? data;

        if (response['data'] != null) {
          data = response['data'];
          print('Using response[data] key');
        } else if (response['point_history'] != null) {
          data = response['point_history'];
          print('Using response[point_history] key');
        } else if (response['points'] != null) {
          data = response['points'];
          print('Using response[points] key');
        }

        if (data != null && data.isNotEmpty) {
          print('Found ${data.length} point history items');
          pointHistoryList.value =
              data.map((item) {
                print('Processing item: $item');
                return PointHistory.fromJson(item);
              }).toList();

          // Calculate available points from unredeemed points
          availablePoints.value = pointHistoryList
              .where((point) => !point.isAlreadyRedeemed)
              .fold(0, (sum, point) => sum + point.point);

          print('Loaded ${pointHistoryList.length} point history items');
          print('Available points: ${availablePoints.value}');
        } else {
          print('No point history data found in response');
          pointHistoryList.clear();
          availablePoints.value = 0;

          // For testing purposes, add some mock data if no real data is available
          _loadTestData();
        }
      } else {
        print('API returned success=false: ${response['message']}');
        throw Exception(response['message'] ?? 'Failed to load point history');
      }
    } catch (e) {
      print('Error loading point history: $e');
      DialogHelper.showErrorDialog(
        title: 'Error',
        message: 'Failed to load point history. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePointSelection(int index) {
    if (index >= pointHistoryList.length) return;

    final pointHistory = pointHistoryList[index];

    // Can't select already redeemed points
    if (pointHistory.isAlreadyRedeemed) {
      DialogHelper.showInfoDialog(
        title: 'Already Redeemed',
        message: 'This point has already been redeemed',
      );
      return;
    }

    // Toggle selection
    final updatedPoint = pointHistory.copyWith(
      isSelected: !pointHistory.isSelected,
    );

    pointHistoryList[index] = updatedPoint;

    // Update selected points list
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

    // Calculate discount (assuming 10,000 yen discount per point)
    totalDiscount.value = totalSelectedPoints.value * 10000.0;

    print(
      'Summary - Points: ${totalSelectedPoints.value}, Amount: ${totalAmount.value}, Discount: ${totalDiscount.value}',
    );
  }

  bool get canRedeem => totalSelectedPoints.value >= minimumPoints;
  bool get hasSelectedPoints => selectedPoints.isNotEmpty;

  Future<void> redeemSelectedPoints() async {
    if (!canRedeem || selectedPoints.isEmpty) return;

    final confirmed = await _showRedeemConfirmation();
    if (!confirmed) return;

    try {
      isLoadingRedeem.value = true;

      final pointIds = selectedPoints.map((point) => point.id).toList();

      // Get user ID from storage
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

      if (response['success'] == true) {
        // Update the redeemed status locally
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

        // Clear selections and recalculate
        selectedPoints.clear();
        _calculateSummary();

        // Recalculate available points
        availablePoints.value = pointHistoryList
            .where((point) => !point.isAlreadyRedeemed)
            .fold(0, (sum, point) => sum + point.point);

        DialogHelper.showSuccessDialog(
          title: 'Success',
          message: 'Points redeemed successfully!',
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to redeem points');
      }
    } catch (e) {
      print('Error redeeming points: $e');
      DialogHelper.showErrorDialog(
        title: 'Error',
        message: 'Failed to redeem points. Please try again.',
      );
    } finally {
      isLoadingRedeem.value = false;
    }
  }

  Future<bool> _showRedeemConfirmation() async {
    bool confirmed = false;

    await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Confirm Redemption',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to redeem:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              'Points: ${totalSelectedPoints.value}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Total Amount: ¥${totalAmount.value.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Discount: ¥${totalDiscount.value.toStringAsFixed(0)}',
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
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              confirmed = true;
              Get.back();
            },
            child: const Text('Redeem', style: TextStyle(color: Colors.green)),
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
    await _loadPointHistory();
  }

  void _loadTestData() {
    print('Loading test data for point history...');

    final testData = [
      PointHistory(
        id: 1,
        userId: 1,
        dealerNumber: 'D001',
        itemCode: 'ITEM001',
        total: '2000.00',
        point: 10,
        purchaseDate: '2024-01-15',
        createdAt: '2024-01-15 10:00:00',
        updatedAt: '2024-01-15 10:00:00',
        isRedeemed: 0,
        redeemDate: null,
      ),
      PointHistory(
        id: 2,
        userId: 1,
        dealerNumber: 'D002',
        itemCode: 'ITEM002',
        total: '1500.00',
        point: 8,
        purchaseDate: '2024-01-20',
        createdAt: '2024-01-20 14:30:00',
        updatedAt: '2024-01-20 14:30:00',
        isRedeemed: 0,
        redeemDate: null,
      ),
      PointHistory(
        id: 3,
        userId: 1,
        dealerNumber: 'D003',
        itemCode: 'ITEM003',
        total: '3000.00',
        point: 15,
        purchaseDate: '2024-01-25',
        createdAt: '2024-01-25 09:15:00',
        updatedAt: '2024-01-25 09:15:00',
        isRedeemed: 1,
        redeemDate: '2024-01-26',
      ),
    ];

    pointHistoryList.value = testData;

    // Calculate available points from unredeemed points
    availablePoints.value = pointHistoryList
        .where((point) => !point.isAlreadyRedeemed)
        .fold(0, (sum, point) => sum + point.point);

    print('Loaded ${pointHistoryList.length} test point history items');
    print('Available points: ${availablePoints.value}');
  }
}

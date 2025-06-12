class RedeemHistory {
  final int id;
  final int userId;
  final String totalAmount;
  final String discount;
  final int totalPoint;
  final String cardNumber;
  final String createdAt;
  final String updatedAt;

  RedeemHistory({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.discount,
    required this.totalPoint,
    required this.cardNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RedeemHistory.fromJson(Map<String, dynamic> json) {
    return RedeemHistory(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalAmount: json['total_amount'] ?? '0.00',
      discount: json['discount'] ?? '0.00',
      totalPoint: json['total_point'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'discount': discount,
      'total_point': totalPoint,
      'card_number': cardNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }


  String get formattedDate {
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt;
    }
  }


  String get formattedTotalAmount {
    try {
      final amount = double.parse(totalAmount);
      return '¥${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } catch (e) {
      return '¥$totalAmount';
    }
  }


  String get formattedDiscount {
    try {
      final discountAmount = double.parse(discount);
      return '¥${discountAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } catch (e) {
      return '¥$discount';
    }
  }
}

class RedeemHistoryResponse {
  final bool success;
  final List<RedeemHistory> redeemHistory;

  RedeemHistoryResponse({required this.success, required this.redeemHistory});

  factory RedeemHistoryResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> historyJson = json['redeem_history'] ?? [];
    final List<RedeemHistory> history =
        historyJson
            .map((historyItem) => RedeemHistory.fromJson(historyItem))
            .toList();

    return RedeemHistoryResponse(
      success: json['success'] ?? false,
      redeemHistory: history,
    );
  }
}

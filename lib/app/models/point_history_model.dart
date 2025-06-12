class PointHistory {
  final int id;
  final int userId;
  final String dealerNumber;
  final String itemCode;
  final String total;
  final int point;
  final String purchaseDate;
  final String createdAt;
  final String updatedAt;
  final int isRedeemed;
  final String? redeemDate;
  bool isSelected;

  PointHistory({
    required this.id,
    required this.userId,
    required this.dealerNumber,
    required this.itemCode,
    required this.total,
    required this.point,
    required this.purchaseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isRedeemed,
    this.redeemDate,
    this.isSelected = false,
  });

  factory PointHistory.fromJson(Map<String, dynamic> json) {
    return PointHistory(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dealerNumber: json['dealer_number'] ?? '',
      itemCode: json['item_code'] ?? '',
      total: json['total']?.toString() ?? '0.00',
      point: json['point'] ?? json['point_receive'] ?? 0,
      purchaseDate: json['purchase_date'] ?? json['date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isRedeemed: json['is_redeemed'] ?? 0,
      redeemDate: json['redeem_date'] ?? json['redemption_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dealer_number': dealerNumber,
      'item_code': itemCode,
      'total': total,
      'point': point,
      'purchase_date': purchaseDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_redeemed': isRedeemed,
      'redeem_date': redeemDate,
    };
  }


  String get formattedTotal => '¥${double.parse(total).toStringAsFixed(0)}';

  String get formattedPurchaseDate {
    try {
      final date = DateTime.parse(purchaseDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return purchaseDate;
    }
  }

  bool get isAlreadyRedeemed => isRedeemed == 1;
  bool get canBeRedeemed => isRedeemed == 0;

  PointHistory copyWith({
    int? id,
    int? userId,
    String? dealerNumber,
    String? itemCode,
    String? total,
    int? point,
    String? purchaseDate,
    String? createdAt,
    String? updatedAt,
    int? isRedeemed,
    String? redeemDate,
    bool? isSelected,
  }) {
    return PointHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dealerNumber: dealerNumber ?? this.dealerNumber,
      itemCode: itemCode ?? this.itemCode,
      total: total ?? this.total,
      point: point ?? this.point,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemDate: redeemDate ?? this.redeemDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

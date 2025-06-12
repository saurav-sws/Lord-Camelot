class PointRecord {
  final int id;
  final int userId;
  final String dealerNumber;
  final String date;
  final String itemCode;
  final String total;
  final String pointReceive;
  final bool isRedeemed;
  final String? redemptionDate;
  final String? createdAt;
  final String? updatedAt;

  PointRecord({
    required this.id,
    required this.userId,
    required this.dealerNumber,
    required this.date,
    required this.itemCode,
    required this.total,
    required this.pointReceive,
    required this.isRedeemed,
    this.redemptionDate,
    this.createdAt,
    this.updatedAt,
  });

  factory PointRecord.fromJson(Map<String, dynamic> json) {
    return PointRecord(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dealerNumber: json['dealer_number'] ?? '',
      date: json['purchase_date'] ?? json['date'] ?? '',
      itemCode: json['item_code'] ?? '',
      total: json['total']?.toString() ?? '0',
      pointReceive: (json['point'] ?? json['point_receive'] ?? 0).toString(),
      isRedeemed: json['is_redeemed'] == 1 || json['is_redeemed'] == true,
      redemptionDate: json['redeem_date'] ?? json['redemption_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dealer_number': dealerNumber,
      'date': date,
      'item_code': itemCode,
      'total': total,
      'point_receive': pointReceive,
      'is_redeemed': isRedeemed ? 1 : 0,
      'redemption_date': redemptionDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PointsResponse {
  final bool success;
  final List<PointRecord> pointRecords;

  PointsResponse({required this.success, required this.pointRecords});

  factory PointsResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> recordsJson = json['point_records'] ?? [];
    final List<PointRecord> records =
        recordsJson
            .map((recordJson) => PointRecord.fromJson(recordJson))
            .toList();

    return PointsResponse(
      success: json['success'] ?? false,
      pointRecords: records,
    );
  }
}

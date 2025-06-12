class User {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String cardNumber;
  final String? name;
  final String? mobile;
  final String? dob;
  final int? totalPoint;

  User({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.cardNumber,
    this.name,
    this.mobile,
    this.dob,
    this.totalPoint,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user') && json['user'] is Map) {
      Map<String, dynamic> userData = json['user'];
      return User(
        accessToken: json['access_token'] ?? json['token'] ?? '',
        tokenType: json['token_type'] ?? 'Bearer',
        userId: userData['id'] ?? 0,
        cardNumber: userData['card_number'] ?? json['card_number'] ?? '',
        name: userData['name'] ?? json['name'],
        mobile: userData['mobile'] ?? json['mobile'],
        dob: userData['dob'] ?? json['dob'],
        totalPoint: userData['total_point'] ?? json['total_point'] ?? 0,
      );
    }

    return User(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      userId: json['user_id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      name: json['name'],
      mobile: json['mobile'],
      dob: json['dob'],
      totalPoint: json['total_point'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'user_id': userId,
      'card_number': cardNumber,
      'name': name,
      'mobile': mobile,
      'dob': dob,
      'total_point': totalPoint,
    };
  }

  String get authorizationHeader => '$tokenType $accessToken';
}

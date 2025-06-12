class User {
  final String accessToken;
  final String tokenType;
  final int userId;

  User({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Check if this is a registration response (may have a different structure)
    if (json.containsKey('user') && json['user'] is Map) {
      Map<String, dynamic> userData = json['user'];
      return User(
        // For registration, access token may be in a different location
        accessToken: json['access_token'] ?? json['token'] ?? '',
        tokenType:
            json['token_type'] ?? 'Bearer', // Default to Bearer if not provided
        userId: userData['id'] ?? 0,
      );
    }

    // Standard login response
    return User(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'user_id': userId,
    };
  }

  String get authorizationHeader => '$tokenType $accessToken';
}

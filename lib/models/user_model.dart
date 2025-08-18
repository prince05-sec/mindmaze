class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final bool hasCompletedOnboarding;
  final bool hasAcceptedConsent;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.hasCompletedOnboarding = false,
    this.hasAcceptedConsent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'hasAcceptedConsent': hasAcceptedConsent,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      hasCompletedOnboarding: map['hasCompletedOnboarding'] ?? false,
      hasAcceptedConsent: map['hasAcceptedConsent'] ?? false,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    bool? hasCompletedOnboarding,
    bool? hasAcceptedConsent,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasAcceptedConsent: hasAcceptedConsent ?? this.hasAcceptedConsent,
    );
  }
}
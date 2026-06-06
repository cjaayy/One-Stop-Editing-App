class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool emailVerified;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerified,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'email_verified': emailVerified,
      'is_admin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      createdAt:
          _parseDate(map['created_at'] ?? map['createdAt']) ?? DateTime.now(),
      updatedAt:
          _parseDate(map['updated_at'] ?? map['updatedAt']) ?? DateTime.now(),
      emailVerified:
          (map['email_verified'] ?? map['emailVerified'] ?? false) as bool,
      isAdmin: (map['is_admin'] ?? map['isAdmin'] ?? false) as bool,
    );
  }

  UserModel copyWith({
    String? name,
    bool? emailVerified,
    bool? isAdmin,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      emailVerified: emailVerified ?? this.emailVerified,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

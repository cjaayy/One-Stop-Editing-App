class AdminTemplateModel {
  final String? id;
  final String name;
  final String category;
  final String sectionName;
  final String aspectRatio;
  final String? description;
  final int? photoCount;
  final String templateType;
  final int iconCodePoint;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminTemplateModel({
    this.id,
    required this.name,
    required this.category,
    required this.sectionName,
    required this.aspectRatio,
    this.description,
    this.photoCount,
    required this.templateType,
    required this.iconCodePoint,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminTemplateModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return AdminTemplateModel(
      id: id,
      name: (map['name'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      sectionName: (map['section_name'] ??
          map['sectionName'] ??
          'Admin Templates') as String,
      aspectRatio:
          (map['aspect_ratio'] ?? map['aspectRatio'] ?? '1:1') as String,
      description: map['description'] as String?,
      photoCount: _asInt(map['photo_count'] ?? map['photoCount']),
      templateType:
          (map['template_type'] ?? map['templateType'] ?? 'photo') as String,
      iconCodePoint:
          _asInt(map['icon_code_point'] ?? map['iconCodePoint']) ?? 0,
      isActive: (map['is_active'] ?? map['isActive'] ?? true) as bool,
      createdAt:
          _parseDate(map['created_at'] ?? map['createdAt']) ?? DateTime.now(),
      updatedAt:
          _parseDate(map['updated_at'] ?? map['updatedAt']) ?? DateTime.now(),
    );
  }

  // Removed Firestore-specific constructor; use `fromMap` for Supabase rows.

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'section_name': sectionName,
      'aspect_ratio': aspectRatio,
      'description': description,
      'photo_count': photoCount,
      'template_type': templateType,
      'icon_code_point': iconCodePoint,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdminTemplateModel copyWith({
    String? id,
    String? name,
    String? category,
    String? sectionName,
    String? aspectRatio,
    String? description,
    int? photoCount,
    String? templateType,
    int? iconCodePoint,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminTemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      sectionName: sectionName ?? this.sectionName,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      description: description ?? this.description,
      photoCount: photoCount ?? this.photoCount,
      templateType: templateType ?? this.templateType,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}

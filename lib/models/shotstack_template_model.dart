class ShotstackTemplateModel {
  final String id;
  final String name;
  final String type; // 'video' or 'image'
  final String aspectRatio; // '9:16', '16:9', '1:1', etc.
  final String previewUrl;
  final String? videoUrl;
  final String description;
  final List<String> mergeFields;
  final List<String> tags;
  final double? duration; // in seconds
  final Map<String, dynamic>? rawTemplate;

  const ShotstackTemplateModel({
    required this.id,
    required this.name,
    required this.type,
    required this.aspectRatio,
    required this.previewUrl,
    this.videoUrl,
    required this.description,
    this.mergeFields = const [],
    this.tags = const [],
    this.duration,
    this.rawTemplate,
  });

  factory ShotstackTemplateModel.fromJson(Map<String, dynamic> json) {
    return ShotstackTemplateModel(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? 'Untitled Template') as String,
      type: (json['type'] ?? 'video') as String,
      aspectRatio: (json['aspectRatio'] ?? json['aspect_ratio'] ?? '9:16') as String,
      previewUrl: (json['previewUrl'] ?? json['preview'] ?? json['thumbnail'] ?? '') as String,
      videoUrl: json['videoUrl'] as String?,
      description: (json['description'] ?? '') as String,
      mergeFields: (json['mergeFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      duration: (json['duration'] as num?)?.toDouble(),
      rawTemplate: json['template'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'aspectRatio': aspectRatio,
      'previewUrl': previewUrl,
      'videoUrl': videoUrl,
      'description': description,
      'mergeFields': mergeFields,
      'tags': tags,
      'duration': duration,
      'template': rawTemplate,
    };
  }
}

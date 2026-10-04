class MediaTemplateApiModel {
  final String id;
  final String name;
  final String type; // 'video' or 'image'
  final String aspectRatio; // '9:16', '16:9', '1:1', '4:5'
  final String previewUrl;
  final String mediaUrl; // High-res image URL or MP4 video URL
  final String description;
  final List<String> tags;
  final double? duration; // Duration in seconds (for videos)
  final String sourceApi; // 'shotstack', 'pexels', 'pixabay', 'curated'
  final List<String> mergeFields;

  const MediaTemplateApiModel({
    required this.id,
    required this.name,
    required this.type,
    required this.aspectRatio,
    required this.previewUrl,
    required this.mediaUrl,
    required this.description,
    this.tags = const [],
    this.duration,
    this.sourceApi = 'curated',
    this.mergeFields = const [],
  });

  factory MediaTemplateApiModel.fromJson(Map<String, dynamic> json) {
    return MediaTemplateApiModel(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? 'Untitled Template') as String,
      type: (json['type'] ?? 'video') as String,
      aspectRatio: (json['aspectRatio'] ?? json['aspect_ratio'] ?? '9:16') as String,
      previewUrl: (json['previewUrl'] ?? json['preview'] ?? json['thumbnail'] ?? '') as String,
      mediaUrl: (json['mediaUrl'] ?? json['media_url'] ?? json['videoUrl'] ?? json['previewUrl'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      duration: (json['duration'] as num?)?.toDouble(),
      sourceApi: (json['sourceApi'] ?? 'curated') as String,
      mergeFields: (json['mergeFields'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'aspectRatio': aspectRatio,
      'previewUrl': previewUrl,
      'mediaUrl': mediaUrl,
      'description': description,
      'tags': tags,
      'duration': duration,
      'sourceApi': sourceApi,
      'mergeFields': mergeFields,
    };
  }
}

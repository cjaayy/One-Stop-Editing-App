class AppTemplateModel {
  final String id;
  final String name;
  final String category;
  final String editorType;
  final int canvasWidth;
  final int canvasHeight;
  final double? durationSeconds;
  final List<TemplateElement> elements;

  const AppTemplateModel({
    required this.id,
    required this.name,
    required this.category,
    required this.editorType,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.elements,
    this.durationSeconds,
  });

  factory AppTemplateModel.fromMap(Map<String, dynamic> map) {
    return AppTemplateModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      editorType:
          map['editor_type']?.toString() ?? map['editorType'] ?? 'collage',
      canvasWidth: (map['canvas_width'] ?? map['canvasWidth'] ?? 1080) as int,
      canvasHeight:
          (map['canvas_height'] ?? map['canvasHeight'] ?? 1920) as int,
      durationSeconds: map['duration_seconds'] == null
          ? null
          : double.tryParse(map['duration_seconds'].toString()),
      elements: ((map['elements'] ?? []) as List)
          .map((item) =>
              TemplateElement.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

class TemplateElement {
  final String id;
  final String type;
  final double x;
  final double y;
  final double w;
  final double h;
  final int zIndex;
  final String? text;
  final String? color;
  final double? fontSize;
  final double? radius;
  final String? assetUrl;
  final double? start;
  final double? duration;

  const TemplateElement({
    required this.id,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.w = 1,
    this.h = 1,
    this.zIndex = 0,
    this.text,
    this.color,
    this.fontSize,
    this.radius,
    this.assetUrl,
    this.start,
    this.duration,
  });

  factory TemplateElement.fromMap(Map<String, dynamic> map) {
    return TemplateElement(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      w: (map['w'] ?? 1).toDouble(),
      h: (map['h'] ?? 1).toDouble(),
      zIndex: map['zIndex'] ?? 0,
      text: map['text']?.toString(),
      color: map['color']?.toString(),
      fontSize: map['fontSize'] == null ? null : (map['fontSize']).toDouble(),
      radius: map['radius'] == null ? null : (map['radius']).toDouble(),
      assetUrl: map['assetUrl']?.toString(),
      start: map['start'] == null ? null : (map['start']).toDouble(),
      duration: map['duration'] == null ? null : (map['duration']).toDouble(),
    );
  }
}

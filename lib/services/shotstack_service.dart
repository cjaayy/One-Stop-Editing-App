import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/shotstack_template_model.dart';

class ShotstackService {
  static const String _defaultEnv = 'stage';

  String get _apiKey {
    try {
      if (dotenv.isInitialized) {
        return (dotenv.env['SHOTSTACK_API_KEY'] ?? '').trim();
      }
    } catch (_) {}
    return '';
  }

  String get _env {
    try {
      if (dotenv.isInitialized) {
        final val = (dotenv.env['SHOTSTACK_ENV'] ?? '').trim().toLowerCase();
        if (val == 'v1' || val == 'prod' || val == 'production') return 'v1';
      }
    } catch (_) {}
    return _defaultEnv;
  }

  bool get isConfigured => _apiKey.isNotEmpty;

  String get _baseUrl => 'https://api.shotstack.io/edit/$_env';

  Map<String, String> get _headers => {
        'x-api-key': _apiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Fetches templates from Shotstack API if configured, otherwise falls back
  /// to curated Shotstack video and image templates.
  Future<List<ShotstackTemplateModel>> getTemplates({String? type}) async {
    if (isConfigured) {
      try {
        final response = await http
            .get(
              Uri.parse('$_baseUrl/templates'),
              headers: _headers,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final list = (data['response']?['templates'] as List<dynamic>?) ??
              (data['templates'] as List<dynamic>?) ??
              [];

          if (list.isNotEmpty) {
            final liveTemplates = list
                .map((e) => ShotstackTemplateModel.fromJson(e as Map<String, dynamic>))
                .toList();

            if (type != null) {
              return liveTemplates.where((t) => t.type == type).toList();
            }
            return liveTemplates;
          }
        }
      } catch (e) {
        debugPrint('Shotstack API live fetch error: $e');
      }
    }

    // Curated high-performance Shotstack video and image templates
    final all = _getCuratedShotstackTemplates();
    if (type != null) {
      return all.where((t) => t.type == type).toList();
    }
    return all;
  }

  /// Triggers a Shotstack cloud render for the specified template and merge fields
  Future<String?> renderTemplate({
    required String templateId,
    required Map<String, dynamic> mergeData,
  }) async {
    if (!isConfigured) {
      throw Exception(
        'Shotstack API key not configured. Add SHOTSTACK_API_KEY to your .env file.',
      );
    }

    final body = jsonEncode({
      'id': templateId,
      'merge': mergeData.entries.map((e) => {
            'find': e.key,
            'replace': e.value,
          }).toList(),
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/templates/render'),
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['response']?['id'] as String?;
    } else {
      throw Exception('Shotstack render failed: ${response.body}');
    }
  }

  /// Checks the progress of an ongoing Shotstack render job
  Future<Map<String, dynamic>?> checkRenderStatus(String renderId) async {
    if (!isConfigured) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/render/$renderId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final resp = json['response'] as Map<String, dynamic>?;
      return {
        'status': resp?['status'], // queued, fetching, rendering, done, failed
        'url': resp?['url'], // Final MP4 / image download URL
        'error': resp?['error'],
      };
    }
    return null;
  }

  /// Curated Shotstack Cloud Templates with direct CDN preview assets
  List<ShotstackTemplateModel> _getCuratedShotstackTemplates() {
    return const [
      // 1. Video Templates (9:16 Vertical Stories / TikTok / Reels)
      ShotstackTemplateModel(
        id: 'shotstack-video-reel-01',
        name: 'Neon Velocity Reel',
        type: 'video',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        description: 'Fast-paced rhythmic transitions for TikTok and Instagram Reels.',
        mergeFields: ['TITLE', 'CAPTION', 'VIDEO_BACKGROUND'],
        tags: ['Reels', 'TikTok', 'Transitions', 'Music'],
        duration: 15.0,
      ),
      ShotstackTemplateModel(
        id: 'shotstack-video-story-02',
        name: 'Minimal Travel Story',
        type: 'video',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        description: 'Clean typographic travel diary with smooth panning animations.',
        mergeFields: ['LOCATION', 'DATE', 'MEDIA_CLIP'],
        tags: ['Travel', 'Vlog', 'Stories'],
        duration: 12.0,
      ),
      ShotstackTemplateModel(
        id: 'shotstack-video-cinematic-03',
        name: 'Cinematic Teaser',
        type: 'video',
        aspectRatio: '16:9',
        previewUrl:
            'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        description: 'Widescreen landscape template with cinematic lower-third text.',
        mergeFields: ['MAIN_HEADLINE', 'SUB_HEADLINE', 'FOOTAGE'],
        tags: ['YouTube', 'Cinematic', 'Landscape'],
        duration: 30.0,
      ),

      // 2. Image / Graphic Templates (1:1 & 4:5 Feed Posts)
      ShotstackTemplateModel(
        id: 'shotstack-image-promo-01',
        name: 'Modern Studio Poster',
        type: 'image',
        aspectRatio: '1:1',
        previewUrl:
            'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&auto=format&fit=crop&q=80',
        description: 'High-contrast promotional square poster with bold typography.',
        mergeFields: ['HERO_TITLE', 'DISCOUNT_TAG', 'PRODUCT_IMAGE'],
        tags: ['Square', 'Promo', 'Graphic'],
      ),
      ShotstackTemplateModel(
        id: 'shotstack-image-portrait-02',
        name: 'Editorial Magazine Cover',
        type: 'image',
        aspectRatio: '4:5',
        previewUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80',
        description: 'Sleek 4:5 portrait layout with clean magazine-style frames.',
        mergeFields: ['ISSUE_TITLE', 'MODEL_IMAGE', 'BYLINE'],
        tags: ['Portrait', 'Fashion', 'Editorial'],
      ),
      ShotstackTemplateModel(
        id: 'shotstack-image-minimal-03',
        name: 'Architectural Minimalist',
        type: 'image',
        aspectRatio: '1:1',
        previewUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800&auto=format&fit=crop&q=80',
        description: 'Sophisticated gallery style layout for photography highlights.',
        mergeFields: ['PHOTOGRAPHER', 'GALLERY_NAME', 'PHOTO_URL'],
        tags: ['Minimal', 'Square', 'Art'],
      ),
    ];
  }
}

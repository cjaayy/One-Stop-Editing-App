import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/media_template_api_model.dart';

class MediaTemplateApiService {
  static final MediaTemplateApiService _instance =
      MediaTemplateApiService._internal();
  factory MediaTemplateApiService() => _instance;
  MediaTemplateApiService._internal();

  String? _customShotstackKey;
  String? _customShotstackEnv;

  String get shotstackApiKey {
    if (_customShotstackKey != null && _customShotstackKey!.isNotEmpty) {
      return _customShotstackKey!;
    }
    try {
      if (dotenv.isInitialized) {
        return (dotenv.env['SHOTSTACK_API_KEY'] ?? '').trim();
      }
    } catch (_) {}
    return '';
  }

  String get shotstackEnv {
    if (_customShotstackEnv != null && _customShotstackEnv!.isNotEmpty) {
      return _customShotstackEnv!;
    }
    try {
      if (dotenv.isInitialized) {
        final val = (dotenv.env['SHOTSTACK_ENV'] ?? '').trim().toLowerCase();
        if (val == 'v1' || val == 'prod' || val == 'production') return 'v1';
      }
    } catch (_) {}
    return 'stage';
  }

  bool get isConfigured => shotstackApiKey.isNotEmpty;

  void setCustomShotstackKey(String key, {String? env}) {
    _customShotstackKey = key.trim();
    if (env != null && env.isNotEmpty) {
      _customShotstackEnv = env.trim().toLowerCase();
    }
  }

  /// Fetch templates (videos and images) from Shotstack API and curated Cloud Engine
  Future<List<MediaTemplateApiModel>> fetchTemplates({
    String? query,
    String? typeFilter, // 'video', 'image', or null for all
    String? aspectRatioFilter, // '9:16', '16:9', '1:1'
  }) async {
    List<MediaTemplateApiModel> results = [];

    // 1. Fetch live Shotstack API templates if configured
    if (isConfigured) {
      try {
        final shotstackTemplates =
            await _fetchShotstack(typeFilter: typeFilter);
        results.addAll(shotstackTemplates);
      } catch (e) {
        debugPrint('Shotstack API fetch error: $e');
      }
    }

    // 2. Augment / fallback with curated Cloud Templates
    results.addAll(_getCuratedCloudTemplates());

    // Deduplicate by ID
    final seenIds = <String>{};
    results = results.where((item) => seenIds.add(item.id)).toList();

    // 3. Apply filters
    var filtered = results;
    if (typeFilter != null && typeFilter.isNotEmpty && typeFilter != 'all') {
      filtered = filtered.where((t) => t.type == typeFilter).toList();
    }

    if (aspectRatioFilter != null &&
        aspectRatioFilter.isNotEmpty &&
        aspectRatioFilter != 'all') {
      filtered =
          filtered.where((t) => t.aspectRatio == aspectRatioFilter).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      filtered = filtered.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q) ||
            t.tags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();
    }

    return filtered;
  }

  /// Shotstack API fetching
  Future<List<MediaTemplateApiModel>> _fetchShotstack(
      {String? typeFilter}) async {
    final list = <MediaTemplateApiModel>[];
    final headers = {
      'x-api-key': shotstackApiKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final env = shotstackEnv;
    final url = 'https://api.shotstack.io/edit/$env/templates';
    final response = await http.get(Uri.parse(url), headers: headers).timeout(
          const Duration(seconds: 8),
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final raw = (data['response']?['templates'] as List<dynamic>?) ??
          (data['templates'] as List<dynamic>?) ??
          [];
      for (final t in raw) {
        final isVid = (t['type'] ?? 'video') == 'video';
        list.add(
          MediaTemplateApiModel(
            id: 'shotstack-${t['id']}',
            name: (t['name'] ?? 'Shotstack Template') as String,
            type: isVid ? 'video' : 'image',
            aspectRatio: (t['aspectRatio'] ?? '9:16') as String,
            previewUrl: (t['previewUrl'] ?? t['thumbnail'] ?? '') as String,
            mediaUrl: (t['videoUrl'] ?? t['previewUrl'] ?? '') as String,
            description:
                (t['description'] ?? 'Shotstack Cloud Template') as String,
            sourceApi: 'shotstack',
            tags: ['Shotstack', isVid ? 'Video' : 'Image'],
            mergeFields: ['TITLE', 'BACKGROUND', 'CAPTION'],
          ),
        );
      }
    }
    return list;
  }

  /// Curated High Quality Cloud Templates (Used out of the box and fallback)
  List<MediaTemplateApiModel> _getCuratedCloudTemplates() {
    return const [
      // 1. VIDEO TEMPLATES
      MediaTemplateApiModel(
        id: 'api-video-reel-neon',
        name: 'Neon Velocity Reel',
        type: 'video',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        description:
            'Fast-paced kinetic typography and beat cuts for Instagram Reels & TikTok.',
        duration: 15.0,
        sourceApi: 'shotstack',
        tags: ['Reels', 'TikTok', 'Vertical', 'Neon', 'Fast'],
        mergeFields: ['HOOK_TEXT', 'BRAND_NAME', 'CALL_TO_ACTION'],
      ),
      MediaTemplateApiModel(
        id: 'api-video-story-travel',
        name: 'Minimal Travel Diary',
        type: 'video',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        description:
            'Cinematic vertical vlog story with smooth slow-motion transitions.',
        duration: 12.0,
        sourceApi: 'shotstack',
        tags: ['Story', 'Travel', 'Vlog', 'Minimal'],
        mergeFields: ['LOCATION', 'DATE_TAG', 'SUBTITLE'],
      ),
      MediaTemplateApiModel(
        id: 'api-video-cinema-teaser',
        name: 'Cinematic Widescreen Teaser',
        type: 'video',
        aspectRatio: '16:9',
        previewUrl:
            'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        description:
            'Landscape film teaser with letterbox bars and dramatic intro sequence.',
        duration: 25.0,
        sourceApi: 'shotstack',
        tags: ['YouTube', 'Cinematic', 'Landscape', 'Trailer'],
        mergeFields: ['EPISODE_TITLE', 'RELEASE_DATE', 'DIRECTOR'],
      ),
      MediaTemplateApiModel(
        id: 'api-video-fitness-pulse',
        name: 'Fitness High Energy',
        type: 'video',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
        description:
            'High-octane workout motivation template with bold timer overlay.',
        duration: 10.0,
        sourceApi: 'shotstack',
        tags: ['Fitness', 'Workout', 'Reels', 'Energy'],
        mergeFields: ['WORKOUT_TYPE', 'REP_COUNT', 'COACH_NAME'],
      ),

      // 2. IMAGE TEMPLATES
      MediaTemplateApiModel(
        id: 'api-image-promo-square',
        name: 'Studio Product Promo',
        type: 'image',
        aspectRatio: '1:1',
        previewUrl:
            'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=1400&auto=format&fit=crop&q=90',
        description:
            'Clean high-converting promotional post for e-commerce and retail.',
        sourceApi: 'shotstack',
        tags: ['Square', 'Promo', 'Ecommerce', 'Marketing'],
        mergeFields: ['OFFER_PERCENT', 'PRODUCT_TITLE', 'SHOP_URL'],
      ),
      MediaTemplateApiModel(
        id: 'api-image-magazine-portrait',
        name: 'Editorial Fashion Cover',
        type: 'image',
        aspectRatio: '4:5',
        previewUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1400&auto=format&fit=crop&q=90',
        description:
            'High-fashion editorial layout with magazine masthead typography.',
        sourceApi: 'shotstack',
        tags: ['Fashion', 'Portrait', 'Instagram', 'Editorial'],
        mergeFields: ['MAGAZINE_TITLE', 'FEATURED_ARTIST', 'SEASON_TAG'],
      ),
      MediaTemplateApiModel(
        id: 'api-image-quote-minimal',
        name: 'Minimalist Architecture Poster',
        type: 'image',
        aspectRatio: '1:1',
        previewUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1400&auto=format&fit=crop&q=90',
        description:
            'Gallery exhibition poster style with elegant sans-serif credits.',
        sourceApi: 'shotstack',
        tags: ['Art', 'Minimal', 'Square', 'Architecture'],
        mergeFields: ['EXHIBIT_NAME', 'CURATOR', 'DATE_RANGE'],
      ),
      MediaTemplateApiModel(
        id: 'api-image-story-graphic',
        name: 'Cyberpunk Story Frame',
        type: 'image',
        aspectRatio: '9:16',
        previewUrl:
            'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=800&auto=format&fit=crop&q=80',
        mediaUrl:
            'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1400&auto=format&fit=crop&q=90',
        description:
            'Vibrant neon gradient border frame ready for vertical mobile stories.',
        sourceApi: 'shotstack',
        tags: ['Cyberpunk', 'Story', 'Neon', 'Vertical'],
        mergeFields: ['STORY_CAPTION', 'SWIPE_UP_TEXT', 'USERNAME'],
      ),
    ];
  }
}

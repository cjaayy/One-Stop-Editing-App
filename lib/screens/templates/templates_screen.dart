import 'package:flutter/material.dart';
import '../../models/admin_template_model.dart';
import '../../models/app_template_model.dart';
import '../../services/template_service.dart';
import '../../utils/constants.dart';
import '../../widgets/gradient_background.dart';
import '../collage/collage_editor_screen.dart';
import 'photo_template_editor_screen.dart';
import 'video_template_editor_screen.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TemplateService _templateService = TemplateService();
  int _selectedCategoryIndex = 0;

  final List<TemplateCategory> _categories = [
    // 1. COLLAGE - Dedicated solely to multi-photo grid layouts
    TemplateCategory(
      name: 'Collage',
      icon: Icons.grid_view_rounded,
      sections: [
        TemplateSection(
          name: 'Basic Grids',
          templates: [
            TemplateItem(
              name: '2 Photo Grid',
              preview: Icons.grid_on,
              aspectRatio: '1:1',
              photoCount: 2,
              type: TemplateType.photo,
              description: 'Side-by-side photo grid',
            ),
            TemplateItem(
              name: '3 Photo Layout',
              preview: Icons.view_comfy_rounded,
              aspectRatio: '1:1',
              photoCount: 3,
              type: TemplateType.photo,
              description: '1 featured + 2 stacked',
            ),
            TemplateItem(
              name: '4 Photo Grid',
              preview: Icons.grid_4x4_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
              description: 'Classic 2x2 square layout',
            ),
            TemplateItem(
              name: '6 Photo Mosaic',
              preview: Icons.dashboard_rounded,
              aspectRatio: '1:1',
              photoCount: 6,
              type: TemplateType.photo,
              description: 'Multi-frame collage gallery',
            ),
          ],
        ),
        TemplateSection(
          name: 'Story & Social Grids',
          templates: [
            TemplateItem(
              name: 'Story Collage',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
              type: TemplateType.photo,
              description: 'Vertical 3-tier story layout',
            ),
            TemplateItem(
              name: 'Feed 4-Grid',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
              description: 'Square feed showcase',
            ),
            TemplateItem(
              name: '5 Photo Showcase',
              preview: Icons.view_quilt_rounded,
              aspectRatio: '1:1',
              photoCount: 5,
              type: TemplateType.photo,
              description: '2 top + 3 bottom layout',
            ),
            TemplateItem(
              name: '9 Photo Grid',
              preview: Icons.grid_on_rounded,
              aspectRatio: '1:1',
              photoCount: 9,
              type: TemplateType.photo,
              description: '3x3 complete grid layout',
            ),
          ],
        ),
      ],
    ),

    // 2. PHOTO TEMPLATES - Real working images and overlays
    TemplateCategory(
      name: 'Photo',
      icon: Icons.photo_camera_rounded,
      sections: [
        TemplateSection(
          name: 'Editorial & Portrait',
          templates: [
            TemplateItem(
              name: 'Editorial Fashion Cover',
              preview: Icons.person_rounded,
              aspectRatio: '4:5',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1400&auto=format&fit=crop&q=90',
              description: 'High-fashion editorial layout',
            ),
            TemplateItem(
              name: 'Cyberpunk Story Frame',
              preview: Icons.brush_rounded,
              aspectRatio: '9:16',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1400&auto=format&fit=crop&q=90',
              description: 'Neon gradient cyberpunk border',
            ),
            TemplateItem(
              name: 'Minimal Architecture',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1400&auto=format&fit=crop&q=90',
              description: 'Gallery exhibition poster style',
            ),
          ],
        ),
        TemplateSection(
          name: 'Commercial & Creative',
          templates: [
            TemplateItem(
              name: 'Studio Product Promo',
              preview: Icons.shopping_bag_rounded,
              aspectRatio: '1:1',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=1400&auto=format&fit=crop&q=90',
              description: 'Clean high-converting marketing promo',
            ),
            TemplateItem(
              name: 'Sunset Horizon Poster',
              preview: Icons.landscape_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1400&auto=format&fit=crop&q=90',
              description: 'Golden hour landscape presentation',
            ),
            TemplateItem(
              name: 'Urban Street Style',
              preview: Icons.style_rounded,
              aspectRatio: '4:5',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1400&auto=format&fit=crop&q=90',
              description: 'Bold streetwear typography banner',
            ),
          ],
        ),
      ],
    ),

    // 3. VIDEO TEMPLATES - Real working videos
    TemplateCategory(
      name: 'Video',
      icon: Icons.videocam_rounded,
      sections: [
        TemplateSection(
          name: 'Short Form & Reels',
          templates: [
            TemplateItem(
              name: 'Neon Velocity Reel',
              preview: Icons.play_circle_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 15.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
              description: 'Fast kinetic beat cuts for mobile',
            ),
            TemplateItem(
              name: 'Minimal Travel Diary',
              preview: Icons.flight_takeoff_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 12.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
              description: 'Cinematic vertical vlog story',
            ),
            TemplateItem(
              name: 'Fitness High Energy',
              preview: Icons.fitness_center_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 10.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
              description: 'High-octane workout motivation',
            ),
          ],
        ),
        TemplateSection(
          name: 'Cinema & Widescreen',
          templates: [
            TemplateItem(
              name: 'Cinematic Teaser',
              preview: Icons.movie_filter_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
              duration: 25.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              description: 'Landscape trailer sequence',
            ),
            TemplateItem(
              name: 'Urban Motion Drift',
              preview: Icons.speed_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
              duration: 15.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
              description: 'Dynamic automotive & street video',
            ),
          ],
        ),
      ],
    ),

    // 4. INSTAGRAM TEMPLATES
    TemplateCategory(
      name: 'Instagram',
      icon: Icons.camera_alt_rounded,
      sections: [
        TemplateSection(
          name: 'Reels & Stories',
          templates: [
            TemplateItem(
              name: 'IG Kinetic Beat Reel',
              preview: Icons.play_circle_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 15.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
              description: 'Trending rhythm cuts for Reels',
            ),
            TemplateItem(
              name: 'Cyberpunk Story Frame',
              preview: Icons.auto_awesome_rounded,
              aspectRatio: '9:16',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1400&auto=format&fit=crop&q=90',
              description: 'Neon aesthetic Instagram story',
            ),
            TemplateItem(
              name: 'Vlog Story Reel',
              preview: Icons.movie_creation_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 12.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
              description: 'Daily life aesthetic story cut',
            ),
          ],
        ),
        TemplateSection(
          name: 'Feed & Posts',
          templates: [
            TemplateItem(
              name: 'IG Editorial Portrait',
              preview: Icons.view_compact_rounded,
              aspectRatio: '4:5',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1400&auto=format&fit=crop&q=90',
              description: 'Standard 4:5 Instagram feed post',
            ),
            TemplateItem(
              name: 'Studio Square Drop',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=1400&auto=format&fit=crop&q=90',
              description: 'Product drop square feed template',
            ),
          ],
        ),
      ],
    ),

    // 5. FACEBOOK TEMPLATES
    TemplateCategory(
      name: 'Facebook',
      icon: Icons.facebook_rounded,
      sections: [
        TemplateSection(
          name: 'Page & Covers',
          templates: [
            TemplateItem(
              name: 'Facebook Page Banner',
              preview: Icons.panorama_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1400&auto=format&fit=crop&q=90',
              description: 'HD Facebook header cover',
            ),
            TemplateItem(
              name: 'Business Event Promo',
              preview: Icons.event_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1400&auto=format&fit=crop&q=90',
              description: 'Professional event announcement',
            ),
          ],
        ),
        TemplateSection(
          name: 'Feed & Video',
          templates: [
            TemplateItem(
              name: 'FB Video Spotlight',
              preview: Icons.ondemand_video_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
              duration: 25.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              description: 'Engaging video news & story',
            ),
            TemplateItem(
              name: 'FB Story Pulse',
              preview: Icons.mobile_screen_share_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 10.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
              description: 'High energy vertical video story',
            ),
          ],
        ),
      ],
    ),

    // 6. YOUTUBE TEMPLATES
    TemplateCategory(
      name: 'YouTube',
      icon: Icons.play_circle_filled_rounded,
      sections: [
        TemplateSection(
          name: 'Thumbnails & Covers',
          templates: [
            TemplateItem(
              name: 'Bold Tech Thumbnail',
              preview: Icons.smart_display_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1400&auto=format&fit=crop&q=90',
              description: 'High CTR thumbnail template',
            ),
            TemplateItem(
              name: 'Gaming Stream Thumbnail',
              preview: Icons.sports_esports_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1400&auto=format&fit=crop&q=90',
              description: 'Epic YouTube gaming header layout',
            ),
          ],
        ),
        TemplateSection(
          name: 'Intros & Shorts',
          templates: [
            TemplateItem(
              name: 'Cinematic Channel Intro',
              preview: Icons.videocam_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
              duration: 25.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              description: 'Official widescreen channel intro',
            ),
            TemplateItem(
              name: 'YouTube Shorts Velocity',
              preview: Icons.bolt_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 15.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
              description: 'Viral Shorts kinetic beat cut',
            ),
          ],
        ),
      ],
    ),

    // 7. TIKTOK TEMPLATES
    TemplateCategory(
      name: 'TikTok',
      icon: Icons.music_note_rounded,
      sections: [
        TemplateSection(
          name: 'Trending Formats',
          templates: [
            TemplateItem(
              name: 'TikTok Kinetic Beat',
              preview: Icons.trending_up_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 15.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
              description: 'Fast beat synchronized video',
            ),
            TemplateItem(
              name: 'Fitness Challenge Trend',
              preview: Icons.fitness_center_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 10.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
              description: 'High intensity workout trend',
            ),
            TemplateItem(
              name: 'Travel Vlog Snapshot',
              preview: Icons.landscape_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
              duration: 12.0,
              previewUrl:
                  'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
              description: 'Aesthetic travel diary clip',
            ),
            TemplateItem(
              name: 'Cyberpunk Cover Frame',
              preview: Icons.image_rounded,
              aspectRatio: '9:16',
              type: TemplateType.photo,
              previewUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=800&auto=format&fit=crop&q=80',
              mediaUrl:
                  'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1400&auto=format&fit=crop&q=90',
              description: 'Eye-catching TikTok cover frame',
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedCategoryIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTemplateSelected(TemplateItem template) {
    final dimensions = _parseAspectRatio(template.aspectRatio);
    final isVideo = template.type == TemplateType.video;
    final appTemplate = AppTemplateModel(
      id: template.name.toLowerCase().replaceAll(' ', '-'),
      name: template.name,
      category: _categories[_selectedCategoryIndex].name,
      editorType: isVideo ? 'video' : 'photo',
      canvasWidth: dimensions[0],
      canvasHeight: dimensions[1],
      elements: isVideo
          ? const []
          : [
              const TemplateElement(
                id: 'background',
                type: 'background',
                color: '#161324',
                zIndex: 0,
              ),
              if (template.mediaUrl != null || template.previewUrl != null)
                TemplateElement(
                  id: 'main-image',
                  type: 'imageSlot',
                  assetUrl: template.mediaUrl ?? template.previewUrl,
                  x: 0,
                  y: 0,
                  w: 1,
                  h: 1,
                  zIndex: 1,
                  radius: 0,
                ),
              TemplateElement(
                id: 'template-title',
                type: 'text',
                text: template.name,
                x: 0.08,
                y: 0.08,
                w: 0.84,
                h: 0.15,
                zIndex: 2,
                color: '#FFFFFF',
                fontSize: 22,
              ),
            ],
    );

    if (isVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoTemplateEditorScreen(
            template: appTemplate,
            initialVideoUrl: template.mediaUrl,
            initialPreviewUrl: template.previewUrl,
          ),
        ),
      );
      return;
    }

    if (template.photoCount != null && template.photoCount! > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollageEditorScreen(
            template: template,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoTemplateEditorScreen(template: appTemplate),
      ),
    );
  }

  List<int> _parseAspectRatio(String ratio) {
    final parts = ratio.split(':');
    if (parts.length != 2) {
      return [1080, 1920];
    }

    final width = int.tryParse(parts[0]) ?? 1080;
    final height = int.tryParse(parts[1]) ?? 1920;
    return [
      width <= 0 ? 1080 : width,
      height <= 0 ? 1920 : height,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AdminTemplateModel>>(
      stream: _templateService.streamActiveTemplates(),
      builder: (context, snapshot) {
        final customTemplates = snapshot.data ?? const <AdminTemplateModel>[];

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  _buildAppBar(),

                  // Category Tabs
                  _buildCategoryTabs(),

                  // Templates Grid
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _categories.map((category) {
                        return _buildTemplatesGrid(
                          category,
                          customTemplates,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          const Expanded(
            child: Text(
              'Templates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Search Button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.only(right: 12),
        tabs: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedCategoryIndex == index;

          return Tab(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple
                    : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : AppColors.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTemplatesGrid(
    TemplateCategory category,
    List<AdminTemplateModel> customTemplates,
  ) {
    final sections = _buildSectionsForCategory(category, customTemplates);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding:
                  EdgeInsets.only(bottom: 12, top: sectionIndex == 0 ? 0 : 16),
              child: Row(
                children: [
                  Icon(
                    section.name.contains('Photo') || section.name.contains('Editorial')
                        ? Icons.photo_rounded
                        : section.name.contains('Video') || section.name.contains('Cinema') || section.name.contains('Reels')
                            ? Icons.videocam_rounded
                            : Icons.grid_view_rounded,
                    size: 20,
                    color: AppColors.accentPink,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    section.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
            // Section Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: section.templates.length,
              itemBuilder: (context, index) {
                return _TemplateCard(
                  template: section.templates[index],
                  onTap: () => _showTemplateSelected(section.templates[index]),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<TemplateSection> _buildSectionsForCategory(
    TemplateCategory category,
    List<AdminTemplateModel> customTemplates,
  ) {
    final sections = List<TemplateSection>.from(category.sections);
    final customCategoryTemplates = customTemplates
        .where((template) => template.category == category.name)
        .toList();

    if (customCategoryTemplates.isNotEmpty) {
      final groupedTemplates = <String, List<TemplateItem>>{};

      for (final template in customCategoryTemplates) {
        groupedTemplates.putIfAbsent(template.sectionName, () => []);
        groupedTemplates[template.sectionName]!
            .add(_templateFromAdminTemplate(template));
      }

      sections.addAll(
        groupedTemplates.entries.map(
          (entry) => TemplateSection(
            name: entry.key,
            templates: entry.value,
          ),
        ),
      );
    }

    return sections;
  }

  TemplateItem _templateFromAdminTemplate(AdminTemplateModel template) {
    final previewIcon = template.iconCodePoint == 0
        ? Icons.grid_view_rounded
        : IconData(template.iconCodePoint, fontFamily: 'MaterialIcons');

    return TemplateItem(
      name: template.name,
      preview: previewIcon,
      aspectRatio: template.aspectRatio,
      description: template.description,
      photoCount:
          template.templateType == 'photo' ? (template.photoCount ?? 1) : null,
      type: template.templateType == 'video'
          ? TemplateType.video
          : TemplateType.photo,
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TemplateItem template;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCollage = template.photoCount != null && template.photoCount! > 1;
    final isVideo = template.type == TemplateType.video;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceBorder,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Area
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (template.previewUrl != null &&
                    template.previewUrl!.isNotEmpty)
                  Image.network(
                    template.previewUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(isCollage),
                  )
                else
                  _buildPlaceholder(isCollage),

                // Subtle dark gradient at bottom for text contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Type Badge (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isVideo
                          ? AppColors.primaryPurple
                          : AppColors.accentPink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVideo
                              ? Icons.videocam_rounded
                              : (isCollage
                                  ? Icons.grid_view_rounded
                                  : Icons.photo_rounded),
                          size: 11,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isVideo
                              ? 'Video'
                              : (isCollage ? 'Grid' : 'Photo'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Aspect ratio / Duration badge (Top Left)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      template.duration != null
                          ? '${template.duration!.toInt()}s • ${template.aspectRatio}'
                          : template.aspectRatio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Play icon overlay for video
                if (isVideo)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info Area
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (template.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    template.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                // Solid Action Button (Green background, no glow, no duplicates)
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isCollage ? 'Create Grid' : 'Use Template',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isCollage) {
    return Container(
      color: const Color(0xFF1E1B2E),
      child: Center(
        child: isCollage
            ? _buildCollageLayoutIcon(template)
            : Icon(
                template.preview,
                size: 40,
                color: Colors.white.withValues(alpha: 0.6),
              ),
      ),
    );
  }

  Widget _buildCollageLayoutIcon(TemplateItem template) {
    final color = Colors.white.withValues(alpha: 0.75);
    const gap = 2.0;
    const size = 52.0;

    return SizedBox(
      width: size,
      height: size,
      child: _buildLayoutForCount(template.photoCount!, color, gap),
    );
  }

  Widget _buildLayoutForCount(int count, Color color, double gap) {
    switch (count) {
      case 2:
        // Two vertical panels side by side
        return Row(
          children: [
            Expanded(child: _cell(color)),
            SizedBox(width: gap),
            Expanded(child: _cell(color)),
          ],
        );
      case 3:
        // One large left, two stacked right
        return Row(
          children: [
            Expanded(flex: 2, child: _cell(color)),
            SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(height: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      case 4:
        // 2x2 grid
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      case 5:
        // 2 top (taller) + 3 bottom (shorter) — matches _buildFivePhotoLayout
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      case 6:
        // 1 wide+1 narrow / 3 equal / 1 full — matches _buildSixPhotoLayout
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: _cell(color),
            ),
          ],
        );
      case 7:
        // 3 top + 2 middle + 2 bottom
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      case 8:
        // 3 top + 3 middle + 2 bottom
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      case 9:
        // 3x3 grid
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
            SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                  SizedBox(width: gap),
                  Expanded(child: _cell(color)),
                ],
              ),
            ),
          ],
        );
      default:
        return Icon(
          Icons.grid_view_rounded,
          size: 48,
          color: color,
        );
    }
  }

  Widget _cell(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class TemplateCategory {
  final String name;
  final IconData icon;
  final List<TemplateSection> sections;

  TemplateCategory({
    required this.name,
    required this.icon,
    required this.sections,
  });
}

class TemplateSection {
  final String name;
  final List<TemplateItem> templates;

  TemplateSection({
    required this.name,
    required this.templates,
  });
}

enum TemplateType { photo, video }

class TemplateItem {
  final String name;
  final IconData preview;
  final String aspectRatio;
  final String? description;
  final int? photoCount;
  final TemplateType type;
  final String? previewUrl;
  final String? mediaUrl;
  final double? duration;

  TemplateItem({
    required this.name,
    required this.preview,
    required this.aspectRatio,
    this.description,
    this.photoCount,
    this.type = TemplateType.photo,
    this.previewUrl,
    this.mediaUrl,
    this.duration,
  });
}



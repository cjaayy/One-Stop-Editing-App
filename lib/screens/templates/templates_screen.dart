import 'package:flutter/material.dart';
import '../../models/admin_template_model.dart';
import '../../models/app_template_model.dart';
import '../../models/media_template_api_model.dart';
import '../../services/media_template_api_service.dart';
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
  final MediaTemplateApiService _mediaApiService = MediaTemplateApiService();
  int _selectedCategoryIndex = 0;

  final List<TemplateCategory> _categories = [
    TemplateCategory(
      name: 'API Templates',
      icon: Icons.auto_awesome_motion_rounded,
      sections: const [],
    ),
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
            ),
            TemplateItem(
              name: '3 Photo Layout',
              preview: Icons.view_comfy_rounded,
              aspectRatio: '1:1',
              photoCount: 3,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: '4 Photo Grid',
              preview: Icons.grid_4x4_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: '6 Photo Mosaic',
              preview: Icons.dashboard_rounded,
              aspectRatio: '1:1',
              photoCount: 6,
              type: TemplateType.photo,
            ),
          ],
        ),
        TemplateSection(
          name: 'Story & Feed',
          templates: [
            TemplateItem(
              name: 'Story Collage',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Feed Post',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'Photo',
      icon: Icons.photo_camera_rounded,
      sections: [
        TemplateSection(
          name: 'Single Photo',
          templates: [
            TemplateItem(
              name: 'Portrait Photo',
              preview: Icons.person_rounded,
              aspectRatio: '9:16',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Landscape Photo',
              preview: Icons.landscape_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Square Photo',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              type: TemplateType.photo,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'Video',
      icon: Icons.videocam_rounded,
      sections: [
        TemplateSection(
          name: 'Short Form',
          templates: [
            TemplateItem(
              name: 'Reels Video',
              preview: Icons.play_circle_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'YouTube Video',
              preview: Icons.smart_display_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Story Video',
              preview: Icons.movie_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'Instagram',
      icon: Icons.camera_alt_rounded,
      sections: [
        TemplateSection(
          name: 'Posts',
          templates: [
            TemplateItem(
              name: 'Instagram Post',
              preview: Icons.grid_view_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Instagram Story',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
              type: TemplateType.photo,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'Facebook',
      icon: Icons.facebook_rounded,
      sections: [
        TemplateSection(
          name: 'Social',
          templates: [
            TemplateItem(
              name: 'Facebook Cover',
              preview: Icons.panorama_rounded,
              aspectRatio: '2.7:1',
              photoCount: 3,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Facebook Post',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1.91:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'YouTube',
      icon: Icons.play_circle_filled_rounded,
      sections: [
        TemplateSection(
          name: 'Video Formats',
          templates: [
            TemplateItem(
              name: 'YouTube Thumbnail',
              preview: Icons.image_rounded,
              aspectRatio: '16:9',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'YouTube Intro',
              preview: Icons.videocam_rounded,
              aspectRatio: '16:9',
              type: TemplateType.video,
            ),
          ],
        ),
      ],
    ),
    TemplateCategory(
      name: 'TikTok',
      icon: Icons.music_note_rounded,
      sections: [
        TemplateSection(
          name: 'Short Video',
          templates: [
            TemplateItem(
              name: 'TikTok Trend',
              preview: Icons.video_library_rounded,
              aspectRatio: '9:16',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'TikTok Cover',
              preview: Icons.image_rounded,
              aspectRatio: '9:16',
              type: TemplateType.photo,
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
    final appTemplate = AppTemplateModel(
      id: template.name,
      name: template.name,
      category: _categories[_selectedCategoryIndex].name,
      editorType: template.type == TemplateType.video ? 'video' : 'photo',
      canvasWidth: dimensions[0],
      canvasHeight: dimensions[1],
      elements: const [],
    );

    if (template.type == TemplateType.video) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoTemplateEditorScreen(template: appTemplate),
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

  void _openMediaTemplate(MediaTemplateApiModel template) {
    final dimensions = _parseAspectRatio(template.aspectRatio);
    final isVideo = template.type == 'video';
    final appTemplate = AppTemplateModel(
      id: template.id,
      name: template.name,
      category: 'API Templates',
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
              TemplateElement(
                id: 'main-image',
                type: 'imageSlot',
                assetUrl: template.mediaUrl,
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PhotoTemplateEditorScreen(template: appTemplate),
        ),
      );
    }
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
                        if (category.name == 'API Templates' ||
                            category.name == 'Shotstack API') {
                          return _ApiTemplatesView(
                            apiService: _mediaApiService,
                            onSelectTemplate: _openMediaTemplate,
                          );
                        }
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
                    section.name == 'Photo'
                        ? Icons.photo_rounded
                        : section.name == 'Video'
                            ? Icons.videocam_rounded
                            : Icons.grid_view_rounded,
                    size: 20,
                    color: const Color(0xFFE91E63),
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
                childAspectRatio: 0.85,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: template.type == TemplateType.video
                            ? [
                                const Color(0xFF9C27B0).withValues(alpha: 0.4),
                                const Color(0xFF673AB7).withValues(alpha: 0.4),
                              ]
                            : [
                                const Color(0xFFE91E63).withValues(alpha: 0.3),
                                const Color(0xFF9C27B0).withValues(alpha: 0.3),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: template.photoCount != null
                          ? _buildCollageLayoutIcon(template)
                          : Icon(
                              template.preview,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                    ),
                  ),
                  // Type Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: template.type == TemplateType.video
                            ? const Color(0xFF9C27B0)
                            : const Color(0xFFE91E63),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            template.type == TemplateType.video
                                ? Icons.videocam_rounded
                                : Icons.photo_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            template.type == TemplateType.video
                                ? 'Video'
                                : 'Photo',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info Area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          template.aspectRatio,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (template.description != null) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            template.description!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (template.photoCount != null) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.photo_library_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${template.photoCount}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
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

  TemplateItem({
    required this.name,
    required this.preview,
    required this.aspectRatio,
    this.description,
    this.photoCount,
    this.type = TemplateType.photo,
  });
}

class _ApiTemplatesView extends StatefulWidget {
  final MediaTemplateApiService apiService;
  final Function(MediaTemplateApiModel) onSelectTemplate;

  const _ApiTemplatesView({
    required this.apiService,
    required this.onSelectTemplate,
  });

  @override
  State<_ApiTemplatesView> createState() => _ApiTemplatesViewState();
}

class _ApiTemplatesViewState extends State<_ApiTemplatesView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all'; // 'all', 'video', 'image', '9:16', '16:9', '1:1'
  late Future<List<MediaTemplateApiModel>> _templatesFuture;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTemplates() {
    String? typeFilter;
    String? ratioFilter;

    if (_selectedFilter == 'video' || _selectedFilter == 'image') {
      typeFilter = _selectedFilter;
    } else if (_selectedFilter == '9:16' ||
        _selectedFilter == '16:9' ||
        _selectedFilter == '1:1') {
      ratioFilter = _selectedFilter;
    }

    setState(() {
      _templatesFuture = widget.apiService.fetchTemplates(
        query: _searchController.text,
        typeFilter: typeFilter,
        aspectRatioFilter: ratioFilter,
      );
    });
  }

  void _showApiSettingsSheet() {
    final shotstackController =
        TextEditingController(text: widget.apiService.shotstackApiKey);
    String selectedEnv = widget.apiService.shotstackEnv;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.surfaceBorder),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.api_rounded,
                      color: AppColors.primaryPurple,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Shotstack API Settings',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connected to Shotstack Video & Image Engine for programmatic cloud templates.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),

                // Shotstack API Key
                _buildApiKeyField(
                  label: 'Shotstack API Key',
                  hint: 'Paste your Sandbox or Production Key',
                  controller: shotstackController,
                ),
                const SizedBox(height: 14),

                // Environment Selector (Sandbox vs Production)
                const Text(
                  'Environment',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => selectedEnv = 'stage'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedEnv == 'stage'
                                ? AppColors.primaryPurple
                                : AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedEnv == 'stage'
                                  ? AppColors.primaryPurple
                                  : AppColors.surfaceBorder,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Sandbox (Free)',
                              style: TextStyle(
                                color: selectedEnv == 'stage'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => selectedEnv = 'v1'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedEnv == 'v1'
                                ? AppColors.accentPink
                                : AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedEnv == 'v1'
                                  ? AppColors.accentPink
                                  : AppColors.surfaceBorder,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Production (Live)',
                              style: TextStyle(
                                color: selectedEnv == 'v1'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Save & Apply Solid Green Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      widget.apiService.setCustomShotstackKey(
                        shotstackController.text,
                        env: selectedEnv,
                      );
                      Navigator.pop(sheetContext);
                      _loadTemplates();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shotstack API Key applied successfully'),
                          backgroundColor: AppColors.accentGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Save & Apply Key'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApiKeyField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            filled: true,
            fillColor: AppColors.backgroundDark,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.surfaceBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryPurple),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status & Filter Controls
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _loadTemplates(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search video & image templates (e.g. reels, vlog)...',
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _loadTemplates();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // API Status Banner & Key Config Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.apiService.isConfigured
                            ? AppColors.accentGreen
                            : AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.apiService.isConfigured
                            ? 'Shotstack API Connected (${widget.apiService.shotstackEnv == 'stage' ? 'Sandbox' : 'Production'})'
                            : 'Shotstack Engine (Curated Mode)',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showApiSettingsSheet,
                      icon: const Icon(Icons.vpn_key_rounded, size: 14),
                      label: const Text('API Key'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'All Media', Icons.auto_awesome_mosaic_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('video', 'Videos', Icons.videocam_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('image', 'Images', Icons.image_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('9:16', 'Reels (9:16)', Icons.stay_current_portrait_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('16:9', 'Cinematic (16:9)', Icons.tv_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('1:1', 'Square (1:1)', Icons.crop_square_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Grid of Templates
        Expanded(
          child: FutureBuilder<List<MediaTemplateApiModel>>(
            future: _templatesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPurple,
                  ),
                );
              }

              final templates = snapshot.data ?? [];
              if (templates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No API templates match your filter',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _searchController.clear();
                          _selectedFilter = 'all';
                          _loadTemplates();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final item = templates[index];
                  return _ApiTemplateCard(
                    template: item,
                    onTap: () => widget.onSelectTemplate(item),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String filterKey, String label, IconData icon) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () {
        if (_selectedFilter != filterKey) {
          setState(() {
            _selectedFilter = filterKey;
            _loadTemplates();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryPurple : AppColors.surfaceBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiTemplateCard extends StatelessWidget {
  final MediaTemplateApiModel template;
  final VoidCallback onTap;

  const _ApiTemplateCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = template.type == 'video';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Thumbnail with aspect ratio & type tags
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: isVideo ? 16 / 9 : 16 / 10,
                  child: Image.network(
                    template.previewUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surfaceDark,
                      child: Icon(
                        isVideo
                            ? Icons.videocam_rounded
                            : Icons.image_rounded,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    ),
                  ),
                ),

                // Top Left Badges: Video (Purple) vs Image (Pink)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              : Icons.photo_camera_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isVideo ? 'Video Template' : 'Image Template',
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

                // Top Right: Aspect ratio tag
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      template.aspectRatio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Bottom Right: Duration badge for videos
                if (isVideo && template.duration != null)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${template.duration!.toInt()}s',
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

                // Source API tag bottom left
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      template.sourceApi.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content and CTA
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  template.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),

                // Merge Fields / Tags
                if (template.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: template.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                ],

                // Single Solid Action Button (No duplicates, solid green)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text('Use Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
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
}


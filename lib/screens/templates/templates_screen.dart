import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  final List<TemplateCategory> _categories = [
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
          ],
        ),
        TemplateSection(
          name: 'Creative Layouts',
          templates: [
            TemplateItem(
              name: '6 Photo Mosaic',
              preview: Icons.dashboard_rounded,
              aspectRatio: '1:1',
              photoCount: 6,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: '9 Photo Grid',
              preview: Icons.apps_rounded,
              aspectRatio: '1:1',
              photoCount: 9,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Heart Collage',
              preview: Icons.favorite_rounded,
              aspectRatio: '1:1',
              photoCount: 5,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Circle Collage',
              preview: Icons.circle_outlined,
              aspectRatio: '1:1',
              photoCount: 7,
              type: TemplateType.photo,
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
          name: 'Photo',
          templates: [
            TemplateItem(
              name: 'Square Post',
              preview: Icons.crop_square_rounded,
              aspectRatio: '1:1',
              description: '1080 x 1080',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Portrait Post',
              preview: Icons.crop_portrait_rounded,
              aspectRatio: '4:5',
              description: '1080 x 1350',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Landscape Post',
              preview: Icons.crop_landscape_rounded,
              aspectRatio: '1.91:1',
              description: '1080 x 566',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Carousel',
              preview: Icons.view_carousel_rounded,
              aspectRatio: '1:1',
              description: 'Multi-slide',
              type: TemplateType.photo,
            ),
          ],
        ),
        TemplateSection(
          name: 'Video',
          templates: [
            TemplateItem(
              name: 'Reel',
              preview: Icons.play_circle_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Story Video',
              preview: Icons.smartphone_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Feed Video',
              preview: Icons.videocam_rounded,
              aspectRatio: '1:1',
              description: '1080 x 1080',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'IGTV',
              preview: Icons.tv_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
          ],
        ),
        TemplateSection(
          name: 'Collage',
          templates: [
            TemplateItem(
              name: 'Story Collage',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Post Collage',
              preview: Icons.grid_view_rounded,
              aspectRatio: '1:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Carousel Collage',
              preview: Icons.view_carousel_rounded,
              aspectRatio: '1:1',
              photoCount: 6,
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
          name: 'Photo',
          templates: [
            TemplateItem(
              name: 'Post Image',
              preview: Icons.image_rounded,
              aspectRatio: '1.91:1',
              description: '1200 x 630',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Cover Photo',
              preview: Icons.panorama_rounded,
              aspectRatio: '2.7:1',
              description: '820 x 312',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Profile Picture',
              preview: Icons.account_circle_rounded,
              aspectRatio: '1:1',
              description: '170 x 170',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Event Cover',
              preview: Icons.event_rounded,
              aspectRatio: '1.91:1',
              description: '1920 x 1005',
              type: TemplateType.photo,
            ),
          ],
        ),
        TemplateSection(
          name: 'Video',
          templates: [
            TemplateItem(
              name: 'Story Video',
              preview: Icons.smartphone_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Feed Video',
              preview: Icons.videocam_rounded,
              aspectRatio: '16:9',
              description: '1280 x 720',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Reel',
              preview: Icons.play_circle_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Ad Video',
              preview: Icons.ads_click_rounded,
              aspectRatio: '1:1',
              description: '1080 x 1080',
              type: TemplateType.video,
            ),
          ],
        ),
        TemplateSection(
          name: 'Collage',
          templates: [
            TemplateItem(
              name: 'Post Collage',
              preview: Icons.grid_view_rounded,
              aspectRatio: '1.91:1',
              photoCount: 4,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Story Collage',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Cover Collage',
              preview: Icons.panorama_rounded,
              aspectRatio: '2.7:1',
              photoCount: 3,
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
          name: 'Photo',
          templates: [
            TemplateItem(
              name: 'Thumbnail',
              preview: Icons.ondemand_video_rounded,
              aspectRatio: '16:9',
              description: '1280 x 720',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Channel Banner',
              preview: Icons.panorama_wide_angle_rounded,
              aspectRatio: '6.2:1',
              description: '2560 x 1440',
              type: TemplateType.photo,
            ),
          ],
        ),
        TemplateSection(
          name: 'Video',
          templates: [
            TemplateItem(
              name: 'End Screen',
              preview: Icons.stop_screen_share_rounded,
              aspectRatio: '16:9',
              description: '1920 x 1080',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Shorts',
              preview: Icons.smartphone_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Standard Video',
              preview: Icons.videocam_rounded,
              aspectRatio: '16:9',
              description: '1920 x 1080',
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
          name: 'Photo',
          templates: [
            TemplateItem(
              name: 'Profile Photo',
              preview: Icons.account_circle_rounded,
              aspectRatio: '1:1',
              description: '200 x 200',
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: 'Photo Post',
              preview: Icons.image_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.photo,
            ),
          ],
        ),
        TemplateSection(
          name: 'Video',
          templates: [
            TemplateItem(
              name: 'TikTok Video',
              preview: Icons.smartphone_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Duet',
              preview: Icons.people_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
            ),
            TemplateItem(
              name: 'Stitch',
              preview: Icons.content_cut_rounded,
              aspectRatio: '9:16',
              description: '1080 x 1920',
              type: TemplateType.video,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Selected: ${template.name}'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'USE',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D0A1C),
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
                    return _buildTemplatesGrid(category);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
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
                color: Colors.white.withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.1),
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
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
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

  Widget _buildTemplatesGrid(TemplateCategory category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: category.sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = category.sections[sectionIndex];
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
                      color: Colors.white.withOpacity(0.1),
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
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
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
                                const Color(0xFF9C27B0).withOpacity(0.4),
                                const Color(0xFF673AB7).withOpacity(0.4),
                              ]
                            : [
                                const Color(0xFFE91E63).withOpacity(0.3),
                                const Color(0xFF9C27B0).withOpacity(0.3),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        template.preview,
                        size: 48,
                        color: Colors.white.withOpacity(0.8),
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
                          color: const Color(0xFFE91E63).withOpacity(0.3),
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
                              color: Colors.white.withOpacity(0.5),
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
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${template.photoCount}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
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

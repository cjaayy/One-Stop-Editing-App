import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';
import '../collage/collage_editor_screen.dart';

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
              name: '5 Photo Split',
              preview: Icons.view_agenda_rounded,
              aspectRatio: '1:1',
              photoCount: 5,
              type: TemplateType.photo,
            ),
            TemplateItem(
              name: '7 Photo Mosaic',
              preview: Icons.view_quilt_rounded,
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
          name: 'Collage',
          templates: [
            TemplateItem(
              name: 'YouTube Collage',
              preview: Icons.grid_view_rounded,
              aspectRatio: '16:9',
              photoCount: 4,
              type: TemplateType.photo,
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
          name: 'Collage',
          templates: [
            TemplateItem(
              name: 'TikTok Collage',
              preview: Icons.auto_awesome_mosaic_rounded,
              aspectRatio: '9:16',
              photoCount: 3,
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
    // Route all photo templates to the collage editor.
    // Non-collage templates use a single-photo layout based on the chosen aspect ratio.
    if (template.type == TemplateType.photo) {
      final editorTemplate = template.photoCount != null
          ? template
          : TemplateItem(
              name: template.name,
              preview: template.preview,
              aspectRatio: template.aspectRatio,
              description: template.description,
              photoCount: 1,
              type: template.type,
            );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollageEditorScreen(template: editorTemplate),
        ),
      );
      return;
    }

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
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.2)),
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

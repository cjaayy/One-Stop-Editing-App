import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/admin_template_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/template_service.dart';
import '../../widgets/gradient_background.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sectionController = TextEditingController(text: 'Admin Templates');
  final _aspectRatioController = TextEditingController(text: '1:1');
  final _descriptionController = TextEditingController();
  final _photoCountController = TextEditingController();

  final TemplateService _templateService = TemplateService();

  final List<String> _categories = const [
    'Collage',
    'Instagram',
    'Facebook',
    'YouTube',
    'TikTok',
  ];

  final List<String> _templateTypes = const ['photo', 'video'];

  final List<IconData> _iconOptions = const [
    Icons.grid_view_rounded,
    Icons.auto_awesome_mosaic_rounded,
    Icons.view_carousel_rounded,
    Icons.crop_square_rounded,
    Icons.image_rounded,
    Icons.play_circle_rounded,
    Icons.smartphone_rounded,
    Icons.videocam_rounded,
    Icons.ondemand_video_rounded,
    Icons.panorama_rounded,
    Icons.dashboard_rounded,
  ];

  String _selectedCategory = 'Instagram';
  String _selectedType = 'photo';
  IconData _selectedIcon = Icons.grid_view_rounded;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _sectionController.dispose();
    _aspectRatioController.dispose();
    _descriptionController.dispose();
    _photoCountController.dispose();
    super.dispose();
  }

  bool get _isPhotoTemplate => _selectedType == 'photo';

  Future<void> _createTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    final photoCount = _isPhotoTemplate
        ? int.tryParse(_photoCountController.text.trim())
        : null;

    if (_isPhotoTemplate && (photoCount == null || photoCount <= 0)) {
      _showSnackBar('Photo count must be greater than zero.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _templateService.createTemplate(
        AdminTemplateModel(
          name: _nameController.text.trim(),
          category: _selectedCategory,
          sectionName: _sectionController.text.trim().isEmpty
              ? 'Admin Templates'
              : _sectionController.text.trim(),
          aspectRatio: _aspectRatioController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          photoCount: photoCount,
          templateType: _selectedType,
          iconCodePoint: _selectedIcon.codePoint,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      _formKey.currentState?.reset();
      _nameController.clear();
      _sectionController.text = 'Admin Templates';
      _aspectRatioController.text = '1:1';
      _descriptionController.clear();
      _photoCountController.clear();
      setState(() {
        _selectedCategory = 'Instagram';
        _selectedType = 'photo';
        _selectedIcon = Icons.grid_view_rounded;
        _isSaving = false;
      });
      _showSnackBar('Template created successfully.');
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showSnackBar('Failed to create template.');
    }
  }

  Future<void> _deleteTemplate(String id) async {
    try {
      await _templateService.deleteTemplate(id);
      _showSnackBar('Template deleted.');
    } catch (e) {
      _showSnackBar('Failed to delete template.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.userModel?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF2D0A1C),
      body: GradientBackground(
        child: SafeArea(
          child: isAdmin
              ? StreamBuilder<List<AdminTemplateModel>>(
                  stream: _templateService.streamTemplates(),
                  builder: (context, snapshot) {
                    final templates =
                        snapshot.data ?? const <AdminTemplateModel>[];
                    return Column(
                      children: [
                        _buildAppBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryCards(templates),
                                const SizedBox(height: 20),
                                _buildCreateTemplateCard(),
                                const SizedBox(height: 20),
                                _buildTemplateList(templates),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 52,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Admin access required',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mark this account as admin in Supabase (profiles) to manage templates.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<AdminTemplateModel> templates) {
    final activeTemplates =
        templates.where((template) => template.isActive).length;
    final categories =
        templates.map((template) => template.category).toSet().length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Templates',
            value: templates.length.toString(),
            icon: Icons.layers_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Active',
            value: activeTemplates.toString(),
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Categories',
            value: categories.toString(),
            icon: Icons.category_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateTemplateCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Template',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'Template name',
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 12),
            _buildDropdown<String>(
              label: 'Category',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _sectionController,
              label: 'Section name',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _aspectRatioController,
              label: 'Aspect ratio',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter an aspect ratio'
                  : null,
            ),
            const SizedBox(height: 12),
            _buildDropdown<String>(
              label: 'Template type',
              value: _selectedType,
              items: _templateTypes,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
            ),
            const SizedBox(height: 12),
            if (_isPhotoTemplate) ...[
              _buildTextField(
                controller: _photoCountController,
                label: 'Photo count',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!_isPhotoTemplate) return null;
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid photo count';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],
            const Text(
              'Preview icon',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _iconOptions.map((icon) {
                final isSelected = _selectedIcon.codePoint == icon.codePoint;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE91E63).withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE91E63)
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _createTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_rounded),
                label: Text(_isSaving ? 'Saving...' : 'Create template'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateList(List<AdminTemplateModel> templates) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Existing Templates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (templates.isEmpty)
            Text(
              'No custom templates yet.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: templates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final template = templates[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          IconData(
                            template.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${template.category} • ${template.sectionName} • ${template.templateType}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template.aspectRatio,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: template.id == null
                            ? null
                            : () => _deleteTemplate(template.id!),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      dropdownColor: const Color(0xFF2D1F3D),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ),
          )
          .toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/gradient_background.dart';
import '../templates/templates_screen.dart';

class CollageEditorScreen extends StatefulWidget {
  final TemplateItem template;

  const CollageEditorScreen({super.key, required this.template});

  @override
  State<CollageEditorScreen> createState() => _CollageEditorScreenState();
}

class _CollageEditorScreenState extends State<CollageEditorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final GlobalKey _collageKey = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();

  late List<File?> _images;
  double _spacing = 4.0;
  double _borderRadius = 8.0;
  Color _backgroundColor = Colors.white;
  bool _isSaving = false;

  final List<Color> _backgroundOptions = [
    Colors.white,
    Colors.black,
    const Color(0xFF2D0A1C),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF673AB7),
    const Color(0xFF3F51B5),
    const Color(0xFF2196F3),
    const Color(0xFF009688),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFFFF5722),
  ];

  @override
  void initState() {
    super.initState();
    final count = widget.template.photoCount ?? 2;
    _images = List<File?>.filled(count, null);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to pick image: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera(int index) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to capture image: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _showImageSourcePicker(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D1F3D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(index);
                    },
                  ),
                  _ImageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera(index);
                    },
                  ),
                  if (_images[index] != null)
                    _ImageSourceOption(
                      icon: Icons.delete_rounded,
                      label: 'Remove',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _images[index] = null;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCollage() async {
    // Check if at least one image is added
    if (_images.every((img) => img == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Please add at least one image'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Capture the collage widget as an image
      final RenderRepaintBoundary boundary = _collageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to capture collage');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final collageDir = Directory('${directory.path}/collages');
      if (!await collageDir.exists()) {
        await collageDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${collageDir.path}/collage_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // Also try saving to Pictures directory for easier access
      try {
        final externalDirs = await getExternalStorageDirectories();
        if (externalDirs != null && externalDirs.isNotEmpty) {
          // Navigate up from app-specific dir to shared storage
          final String externalPath = externalDirs.first.path;
          final parts = externalPath.split('/');
          final androidIndex = parts.indexOf('Android');
          if (androidIndex > 0) {
            final basePath = parts.sublist(0, androidIndex).join('/');
            final picturesDir = Directory('$basePath/Pictures/OneStopEditor');
            if (!await picturesDir.exists()) {
              await picturesDir.create(recursive: true);
            }
            final galleryPath = '${picturesDir.path}/collage_$timestamp.png';
            await file.copy(galleryPath);
          }
        }
      } catch (_) {
        // Fallback: file is still saved in app documents
      }

      if (mounted) {
        _showSaveSuccessDialog(filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to save: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSaveSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1F3D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
            SizedBox(width: 12),
            Text('Saved!', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your collage has been saved successfully!',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder, color: Color(0xFFE91E63), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      filePath.split('/').last,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D0A1C),
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Template info
                            _buildTemplateInfo(),
                            const SizedBox(height: 16),

                            // Collage Preview
                            _buildCollagePreview(),
                            const SizedBox(height: 20),

                            // Customization Options
                            _buildCustomizationSection(),
                            const SizedBox(height: 20),

                            // Image slots list
                            _buildImageSlotsList(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isSaving) _buildSavingOverlay(),
              ],
            ),
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
          Expanded(
            child: Text(
              widget.template.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Save Button
          GestureDetector(
            onTap: _isSaving ? null : _saveCollage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateInfo() {
    final int filledCount = _images.where((img) => img != null).length;
    final int totalCount = _images.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.template.preview,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$filledCount / $totalCount photos added',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aspect ratio: ${widget.template.aspectRatio}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Progress indicator
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: filledCount / totalCount,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE91E63),
                  ),
                  strokeWidth: 3,
                ),
                Text(
                  '$filledCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollagePreview() {
    // Determine aspect ratio for the container
    final double aspectRatio = _parseAspectRatio(widget.template.aspectRatio);

    return Center(
      child: RepaintBoundary(
        key: _collageKey,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius),
              child: _buildCollageLayout(),
            ),
          ),
        ),
      ),
    );
  }

  double _parseAspectRatio(String ratio) {
    final parts = ratio.split(':');
    if (parts.length == 2) {
      final w = double.tryParse(parts[0]) ?? 1;
      final h = double.tryParse(parts[1]) ?? 1;
      return w / h;
    }
    return 1.0;
  }

  Widget _buildCollageLayout() {
    final int count = _images.length;

    switch (count) {
      case 2:
        return _buildTwoPhotoLayout();
      case 3:
        return _buildThreePhotoLayout();
      case 4:
        return _buildFourPhotoLayout();
      case 5:
        return _buildFivePhotoLayout();
      case 6:
        return _buildSixPhotoLayout();
      case 7:
        return _buildSevenPhotoLayout();
      case 9:
        return _buildNinePhotoLayout();
      default:
        return _buildGridLayout(count);
    }
  }

  Widget _buildTwoPhotoLayout() {
    return Row(
      children: [
        Expanded(child: _buildImageSlot(0)),
        SizedBox(width: _spacing),
        Expanded(child: _buildImageSlot(1)),
      ],
    );
  }

  Widget _buildThreePhotoLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildImageSlot(0),
        ),
        SizedBox(width: _spacing),
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildImageSlot(1)),
              SizedBox(height: _spacing),
              Expanded(child: _buildImageSlot(2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourPhotoLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(0)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(1)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(2)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFivePhotoLayout() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(0)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(1)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(2)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(3)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSixPhotoLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildImageSlot(0)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(1)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(2)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(3)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(4)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: _buildImageSlot(5),
        ),
      ],
    );
  }

  Widget _buildSevenPhotoLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(0)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(1)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(2)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(3)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(4)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(5)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(6)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNinePhotoLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(0)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(1)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(2)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(3)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(4)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(5)),
            ],
          ),
        ),
        SizedBox(height: _spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildImageSlot(6)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(7)),
              SizedBox(width: _spacing),
              Expanded(child: _buildImageSlot(8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridLayout(int count) {
    final int columns = count <= 4 ? 2 : 3;
    final int rows = (count / columns).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        final int startIdx = rowIndex * columns;
        final int endIdx = (startIdx + columns).clamp(0, count);
        final rowItems = List.generate(endIdx - startIdx, (i) => startIdx + i);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: rowIndex > 0 ? _spacing : 0),
            child: Row(
              children: rowItems.asMap().entries.map((entry) {
                return Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: entry.key > 0 ? _spacing : 0),
                    child: _buildImageSlot(entry.value),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageSlot(int index) {
    final File? image = _images[index];

    return GestureDetector(
      onTap: () => _showImageSourcePicker(index),
      child: Container(
        decoration: BoxDecoration(
          color: image == null ? Colors.grey.withOpacity(0.2) : null,
        ),
        child: image != null
            ? Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      size: 32,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customize',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Background Color
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.palette_rounded,
                      color: Color(0xFFE91E63), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Background Color',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _backgroundOptions.length,
                  itemBuilder: (context, index) {
                    final color = _backgroundOptions[index];
                    final isSelected = color.value == _backgroundColor.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _backgroundColor = color);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE91E63)
                                : Colors.white.withOpacity(0.2),
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 18,
                                color: color == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Spacing Slider
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.space_bar_rounded,
                      color: Color(0xFFE91E63), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Spacing',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_spacing.toInt()}px',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _spacing,
                min: 0,
                max: 20,
                divisions: 20,
                activeColor: const Color(0xFFE91E63),
                inactiveColor: Colors.white.withOpacity(0.1),
                onChanged: (value) {
                  setState(() => _spacing = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Border Radius Slider
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.rounded_corner_rounded,
                      color: Color(0xFFE91E63), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Corner Radius',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_borderRadius.toInt()}px',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _borderRadius,
                min: 0,
                max: 30,
                divisions: 30,
                activeColor: const Color(0xFFE91E63),
                inactiveColor: Colors.white.withOpacity(0.1),
                onChanged: (value) {
                  setState(() => _borderRadius = value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlotsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Photo Slots',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _addAllImages,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded,
                        color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Add All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_images.length, (index) {
          return _buildImageSlotTile(index);
        }),
      ],
    );
  }

  Widget _buildImageSlotTile(int index) {
    final File? image = _images[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: image != null ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            image: image != null
                ? DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: image == null
              ? Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        title: Text(
          image != null ? 'Photo ${index + 1}' : 'Empty Slot ${index + 1}',
          style: TextStyle(
            color: Colors.white.withOpacity(image != null ? 1 : 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          image != null ? 'Tap to change' : 'Tap to add photo',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null)
              GestureDetector(
                onTap: () {
                  setState(() => _images[index] = null);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showImageSourcePicker(index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  image != null ? Icons.swap_horiz_rounded : Icons.add_rounded,
                  color: const Color(0xFFE91E63),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showImageSourcePicker(index),
      ),
    );
  }

  Future<void> _addAllImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          for (int i = 0; i < pickedFiles.length && i < _images.length; i++) {
            _images[i] = File(pickedFiles[i].path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to pick images: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Widget _buildSavingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
            ),
            SizedBox(height: 16),
            Text(
              'Saving collage...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? const Color(0xFFE91E63);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: displayColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: displayColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

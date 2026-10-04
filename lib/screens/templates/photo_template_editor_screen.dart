import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/app_template_model.dart';
import '../../utils/constants.dart';

class PhotoTemplateEditorScreen extends StatefulWidget {
  final AppTemplateModel template;

  const PhotoTemplateEditorScreen({
    super.key,
    required this.template,
  });

  @override
  State<PhotoTemplateEditorScreen> createState() =>
      _PhotoTemplateEditorScreenState();
}

class _PhotoTemplateEditorScreenState extends State<PhotoTemplateEditorScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  static const _galleryChannel = MethodChannel('com.onestopeditor/gallery');

  final Map<String, File> _selectedImages = {};
  final Map<String, String> _editedTexts = {};
  bool _isSaving = false;

  Future<void> _pickImageForSlot(String elementId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _selectedImages[elementId] = File(image.path);
    });
  }

  Color _parseColor(String? hex, {Color fallback = Colors.white}) {
    if (hex == null || hex.isEmpty) return fallback;
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  Future<void> _exportPhoto() async {
    final renderObject = _canvasKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) return;

    setState(() => _isSaving = true);

    try {
      final ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to capture image');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/template_photo_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await _galleryChannel.invokeMethod('saveImageToGallery', {
        'filePath': filePath,
        'albumName': 'OneStopEditor',
      });

      try {
        await file.delete();
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo saved to your gallery'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save photo: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.template.canvasWidth / widget.template.canvasHeight;

    final rawElements = widget.template.elements.isEmpty
        ? _buildFallbackElements()
        : widget.template.elements;
    final elements = List<TemplateElement>.from(rawElements)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.template.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _exportPhoto,
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 16),
              label: const Text('Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: RepaintBoundary(
                key: _canvasKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;

                    return Stack(
                      children: elements.map((element) {
                        return Positioned(
                          left: element.x * width,
                          top: element.y * height,
                          width: element.w * width,
                          height: element.h * height,
                          child: _buildElement(element),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TemplateElement> _buildFallbackElements() {
    return const [
      TemplateElement(
        id: 'background',
        type: 'background',
        color: '#161324',
        zIndex: 0,
      ),
      TemplateElement(
        id: 'main-image',
        type: 'imageSlot',
        x: 0,
        y: 0,
        w: 1,
        h: 1,
        zIndex: 1,
        radius: 0,
      ),
    ];
  }

  Widget _buildElement(TemplateElement element) {
    switch (element.type) {
      case 'background':
        return Container(
          color: _parseColor(element.color, fallback: AppColors.surfaceDark),
        );
      case 'imageSlot':
        final file = _selectedImages[element.id];
        return GestureDetector(
          onTap: () => _pickImageForSlot(element.id),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(element.radius ?? 0),
            child: Container(
              color: AppColors.surfaceDark,
              child: file != null
                  ? Image.file(
                      file,
                      fit: BoxFit.cover,
                    )
                  : (element.assetUrl != null && element.assetUrl!.isNotEmpty)
                      ? Image.network(
                          element.assetUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 40,
                                color: AppColors.primaryPurple,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to choose photo',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        );
      case 'text':
        final currentText = _editedTexts[element.id] ?? element.text ?? '';
        return GestureDetector(
          onTap: () async {
            final controller = TextEditingController(text: currentText);
            final result = await showDialog<String>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: AppColors.surfaceDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.surfaceBorder),
                ),
                title: const Text(
                  'Edit Text',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter text',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.primaryPurple),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, controller.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            );

            if (result != null && mounted) {
              setState(() {
                _editedTexts[element.id] = result;
              });
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              currentText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: element.fontSize ?? 24,
                color: _parseColor(element.color, fallback: Colors.white),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/app_template_model.dart';

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

  final Map<String, File> _selectedImages = {};
  final Map<String, String> _editedTexts = {};

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

    final ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo export is ready (${pngBytes.length} bytes)'),
        backgroundColor: const Color(0xFF9C27B0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.template.canvasWidth / widget.template.canvasHeight;

    final elements = [...widget.template.elements]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return Scaffold(
      backgroundColor: const Color(0xFF2D0A1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A1C),
        foregroundColor: Colors.white,
        title: Text(widget.template.name),
        actions: [
          IconButton(
            onPressed: _exportPhoto,
            icon: const Icon(Icons.download_rounded),
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

  Widget _buildElement(TemplateElement element) {
    switch (element.type) {
      case 'background':
        return Container(
          color: _parseColor(element.color, fallback: Colors.white),
        );
      case 'imageSlot':
        final file = _selectedImages[element.id];
        return GestureDetector(
          onTap: () => _pickImageForSlot(element.id),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(element.radius ?? 0),
            child: Container(
              color: Colors.grey.shade300,
              child: file == null
                  ? const Center(
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : Image.file(
                      file,
                      fit: BoxFit.cover,
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
                backgroundColor: const Color(0xFF2D1F3D),
                title: const Text(
                  'Edit Text',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext, controller.text),
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
                color: _parseColor(element.color, fallback: Colors.black),
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

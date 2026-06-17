import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/app_template_model.dart';

class VideoTemplateEditorScreen extends StatefulWidget {
  final AppTemplateModel template;

  const VideoTemplateEditorScreen({
    super.key,
    required this.template,
  });

  @override
  State<VideoTemplateEditorScreen> createState() =>
      _VideoTemplateEditorScreenState();
}

class _VideoTemplateEditorScreenState extends State<VideoTemplateEditorScreen> {
  final ImagePicker _picker = ImagePicker();
  static const _galleryChannel = MethodChannel('com.onestopeditor/gallery');

  File? _selectedVideo;
  bool _isSaving = false;
  bool _isLoadingVideo = false;

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/picked_video_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      await video.saveTo(tempFile.path);
      debugPrint('Selected video path: ${tempFile.path}');
      debugPrint(
          'Selected video exists after save: ${await tempFile.exists()}');

      if (!mounted) return;
      setState(() {
        _isLoadingVideo = true;
        _selectedVideo = tempFile;
      });

      if (!mounted) return;
      setState(() {
        _isLoadingVideo = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingVideo = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportVideo() async {
    if (_selectedVideo == null) return;

    setState(() => _isSaving = true);

    try {
      final file = File(_selectedVideo!.path);
      if (!await file.exists()) {
        throw Exception('Selected video file no longer exists');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${directory.path}/template_video_$timestamp.mp4';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(await file.readAsBytes());

      await _galleryChannel.invokeMethod('saveMediaToGallery', {
        'filePath': outputPath,
        'albumName': 'OneStopEditor',
      });

      try {
        await outputFile.delete();
      } catch (_) {}

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video saved to your gallery'),
          backgroundColor: Color(0xFF9C27B0),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save video: $e'),
          backgroundColor: Colors.red,
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

    return Scaffold(
      backgroundColor: const Color(0xFF2D0A1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A1C),
        foregroundColor: Colors.white,
        title: Text(widget.template.name),
        actions: [
          IconButton(
            onPressed:
                _selectedVideo == null || _isSaving ? null : _exportVideo,
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: GestureDetector(
              onTap: _pickVideo,
              child: Container(
                color: Colors.black,
                child: _selectedVideo == null
                    ? Center(
                        child: _isLoadingVideo
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Tap to add a video',
                                style: TextStyle(color: Colors.white70),
                              ),
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 64,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Video selected',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 24,
                            right: 24,
                            top: 24,
                            child: Text(
                              'Your Video Title',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

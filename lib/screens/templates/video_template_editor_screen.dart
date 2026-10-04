import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/app_template_model.dart';
import '../../utils/constants.dart';

class VideoTemplateEditorScreen extends StatefulWidget {
  final AppTemplateModel template;
  final String? initialVideoUrl;
  final String? initialPreviewUrl;

  const VideoTemplateEditorScreen({
    super.key,
    required this.template,
    this.initialVideoUrl,
    this.initialPreviewUrl,
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
  String _videoTitle = 'Your Video Title';
  bool _isDownloadingTemplate = false;

  @override
  void initState() {
    super.initState();
    _videoTitle = widget.template.name;
    if (widget.initialVideoUrl != null && widget.initialVideoUrl!.isNotEmpty) {
      _cacheTemplateVideo(widget.initialVideoUrl!);
    }
  }

  Future<void> _cacheTemplateVideo(String url) async {
    try {
      setState(() => _isDownloadingTemplate = true);
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
          '${tempDir.path}/template_api_vid_${DateTime.now().millisecondsSinceEpoch}.mp4',
        );
        await tempFile.writeAsBytes(response.bodyBytes);

        if (mounted) {
          setState(() {
            _selectedVideo = tempFile;
            _isDownloadingTemplate = false;
          });
        }
      } else {
        if (mounted) setState(() => _isDownloadingTemplate = false);
      }
    } catch (e) {
      debugPrint('Template video download error: $e');
      if (mounted) setState(() => _isDownloadingTemplate = false);
    }
  }

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
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  Future<void> _editTitle() async {
    final controller = TextEditingController(text: _videoTitle);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceBorder),
        ),
        title: const Text(
          'Edit Video Title',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter title overlay',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.backgroundDark,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
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

    if (result != null && result.trim().isNotEmpty && mounted) {
      setState(() {
        _videoTitle = result.trim();
      });
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
          backgroundColor: AppColors.accentGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save video: $e'),
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
              onPressed: _selectedVideo == null || _isSaving ? null : _exportVideo,
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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background Video / Preview
                        if (_selectedVideo != null)
                          Positioned.fill(
                            child: Container(
                              color: const Color(0xFF151515),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled_rounded,
                                      color: AppColors.primaryPurple,
                                      size: 56,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Video Media Ready',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else if (widget.initialPreviewUrl != null &&
                            widget.initialPreviewUrl!.isNotEmpty)
                          Positioned.fill(
                            child: Image.network(
                              widget.initialPreviewUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: AppColors.surfaceDark),
                            ),
                          )
                        else
                          Center(
                            child: _isLoadingVideo || _isDownloadingTemplate
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryPurple,
                                  )
                                : const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam_rounded,
                                        size: 48,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No video selected',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),

                        // Title Overlay
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 24,
                          child: GestureDetector(
                            onTap: _editTitle,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryPurple,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _videoTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Loading indicator overlay
                        if (_isDownloadingTemplate)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      color: AppColors.accentGreen,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Downloading template footage...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
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

          // Bottom Editor Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.surfaceDark,
              border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _editTitle,
                    icon: const Icon(Icons.title_rounded, size: 16),
                    label: const Text('Edit Title'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.surfaceBorder),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingVideo ? null : _pickVideo,
                    icon: const Icon(Icons.video_library_rounded, size: 16),
                    label: const Text('Replace Video'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

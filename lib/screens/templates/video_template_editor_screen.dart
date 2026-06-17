import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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

  File? _selectedVideo;
  VideoPlayerController? _controller;

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    final file = File(video.path);
    _controller?.dispose();
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    await controller.setLooping(true);
    await controller.play();

    if (!mounted) return;

    setState(() {
      _selectedVideo = file;
      _controller = controller;
    });
  }

  Future<void> _exportVideo() async {
    if (_selectedVideo == null) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video export will be implemented in the next step.'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
            onPressed: _selectedVideo == null ? null : _exportVideo,
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
                child: _selectedVideo == null || _controller == null
                    ? const Center(
                        child: Text(
                          'Tap to add a video',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: VideoPlayer(_controller!),
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

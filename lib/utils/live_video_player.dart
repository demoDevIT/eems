import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class LiveVideoPlayer extends StatefulWidget {
  final String url; // Pass your live/video URL

  const LiveVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  _LiveVideoPlayerState createState() => _LiveVideoPlayerState();
}

class _LiveVideoPlayerState extends State<LiveVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.url);

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true, // loop for live video
        allowFullScreen: true,
        allowMuting: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print("Error initializing video player: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
        child: Text(
          "Failed to load video",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 17/8,
      child: Chewie(controller: _chewieController!),
    );
  }
}

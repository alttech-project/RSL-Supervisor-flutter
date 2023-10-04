import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utils/helpers/basic_utils.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final void Function(ChewieController) chewieController;

  const VideoItems({
    required this.videoPlayerController,
    required this.looping,
    required this.autoplay,
    required this.chewieController,
    required Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 5 / 8,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        printLogs("Video Player Error : ${errorMessage}");
        return const Center(
          child: Text(
            "Something went wrong!",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    // widget.videoController(_chewieController);
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          child: Chewie(
            controller: _chewieController,
          ),
        ));
  }
}

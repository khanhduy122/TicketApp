import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:video_player/video_player.dart';

class PlayVideoTrailerScreen extends StatefulWidget {
  const PlayVideoTrailerScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<PlayVideoTrailerScreen> createState() => _PlayVideoTrailerScreenState();
}

class _PlayVideoTrailerScreenState extends State<PlayVideoTrailerScreen> {

  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;

  Future<void> _loadVideoFormUrl() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.movie.trailer));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowMuting: false,
      customControls: const MaterialControls(),
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.red,
        bufferedColor: AppColors.grey,
        backgroundColor: AppColors.grey,
      ),
      showOptions: false,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadVideoFormUrl();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: _videoPlayerController.value.isInitialized ? _buildVideoController(context) : _buildPlaceholder(context)
      ),
    );
  }

  SizedBox _buildVideoController(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 50.h,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  SizedBox _buildPlaceholder(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3, 
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ImageNetworkWidget(
            url: widget.movie.banner!, 
            height: MediaQuery.of(context).size.height / 3, 
            width: MediaQuery.of(context).size.width
          ),
          const Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
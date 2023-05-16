import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

bool isMuted = true;

class FeedItem extends StatefulWidget {
  //Url to play video
  final String url;
  const FeedItem({Key? key, required this.url}) : super(key: key);

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  //player controller
  VideoPlayerController? _controller;

  bool isShowMute = false;

  double volume = 1;

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    //initialize player
    initializePlayer(widget.url);
  }

//Initialize Video Player
  void initializePlayer(String url) async {
    final fileInfo = await checkCacheFor(url);
    if (fileInfo == null) {
      _controller = VideoPlayerController.network(url);
      _controller!.initialize().then((value) {
        cachedForUrl(url);
        setState(() {
          _controller!.setVolume(isMuted ? 0 : 1);
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
    } else {
      final file = fileInfo.file;
      _controller = VideoPlayerController.file(file);
      _controller!.initialize().then((value) {
        setState(() {
          _controller!.setVolume(isMuted ? 0 : 1);
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
    }
  }

//: check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

//:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

//:Dispose
  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_controller == null)
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          )
        : ((_controller!.value.isInitialized)
            ? Stack(
                children: [
                  GestureDetector(
                      onLongPressStart: (details) => pause(),
                      onLongPressEnd: (details) => play(),
                      onTap: () async => showMute(),
                      child: VideoPlayer(_controller!)),
                  Center(
                      child: isShowMute
                          ? isMuted
                              ? const MutedIcon()
                              : const UnMutedIcon()
                          : const SizedBox())
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ));
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      if (isMuted) {
        _controller!.setVolume(0);
      } else {
        _controller!.setVolume(1);
      }
    });
  }

  void pause() {
    _controller!.pause();
    setState(() {});
  }

  void play() {
    _controller!.play();
    setState(() {});
  }

  Future showMute() async {
    toggleMute();
    isShowMute = !isShowMute;
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    isShowMute = !isShowMute;
    setState(() {});
  }
}

class MutedIcon extends StatelessWidget {
  const MutedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 32,
      backgroundColor: Colors.black26,
      child: Icon(
        Icons.volume_off,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}

class UnMutedIcon extends StatelessWidget {
  const UnMutedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 32,
      backgroundColor: Colors.black26,
      child: Icon(
        Icons.volume_up,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}

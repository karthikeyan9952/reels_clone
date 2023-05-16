import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import 'mute_icon.dart';
import 'unmute_icon.dart';

bool isMuted = true;

class Video extends StatefulWidget {
  final String url;
  const Video({Key? key, required this.url}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController? _controller;

  bool isShowMute = false;

  double volume = 1;

  Logger logger = Logger();

  final FlareControls flareControls = FlareControls();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    initializePlayer(widget.url);
  }

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

  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {});
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
                      onDoubleTap: () => setState(() {
                            isLiked = !isLiked;
                            flareControls.play("like");
                            logger.w("message");
                          }),
                      onLongPressStart: (details) => pause(),
                      onLongPressEnd: (details) => play(),
                      onTap: () async => showMute(),
                      child: VideoPlayer(_controller!)),
                  Center(
                      child: isShowMute
                          ? isMuted
                              ? const MutedIcon()
                              : const UnMutedIcon()
                          : const SizedBox()),
                  Center(
                    child: Container(
                        width: double.infinity,
                        height: 250,
                        child: Center(
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: FlareActor(
                              'assets/instagram_like.flr',
                              controller: flareControls,
                              animation: 'idle',
                            ),
                          ),
                        )),
                  ),
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

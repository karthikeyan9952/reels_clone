import 'package:flutter/material.dart';
import 'package:reels_clone/view/widgets/video.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({Key? key}) : super(key: key);
  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  //properties

  //to check which index is currently played
  int currentIndex = 0;

  //static content
  final List<String> urls = const [
    // "https://mukthi.life/admin/public/attachment/YbmnMFc57Y.mp4",
    "https://mukthi.life/admin/public/attachment/mmo5uFGiMF.mp4",
    "https://mukthi.life/admin/public/attachment/KAIAzgA1bU.mp4",
    "https://mukthi.life/admin/public/attachment/NsRvftLNQo.mp4",
    "https://mukthi.life/admin/public/attachment/5pLk9D8owL.mp4",
    "https://mukthi.life/admin/public/attachment/LmTRNgm0zA.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: urls.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (ctx, index) {
          return Video(url: urls[index]);
        },
      ),
    );
  }
}

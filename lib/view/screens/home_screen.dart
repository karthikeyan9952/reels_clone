import 'package:flutter/material.dart';
import 'package:reels_clone/view/widgets/player_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlayerController(),
      ),
    );
  }
}

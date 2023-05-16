import 'package:flutter/material.dart';

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

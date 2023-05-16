import 'package:flutter/material.dart';

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

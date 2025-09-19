import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredBackdropImage extends StatelessWidget {
  const BlurredBackdropImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      height: MediaQuery.of(context).size.height / 1.5,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.0)),
        ),
      ),
    );
  }
}

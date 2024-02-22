import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key, 
    this.size = 10
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const CircularProgressIndicator(
        strokeWidth: 1.5,
      ),
    );
  }
}

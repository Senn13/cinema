import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double height;

  const Logo({
    Key? key,
    @required required this.height,
  }) : assert(height != null, 'height must not be null'),
       assert(height > 0, 'height should be greater than 0'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/pngs/logo.png',
      color: Colors.white,
      height: height.h.toDouble(),
    );
  }
}
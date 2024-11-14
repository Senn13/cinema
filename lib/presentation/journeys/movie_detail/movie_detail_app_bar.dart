import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:flutter/material.dart';

class MovieDetailAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: Sizes.dimen_12.h.toDouble(),
          ),
        ),
        Icon(
          Icons.favorite_border,
          color: Colors.white,
          size: Sizes.dimen_12.h.toDouble(),
        ),
      ],
    );
  }
}
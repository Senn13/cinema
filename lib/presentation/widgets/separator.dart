import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.dimen_1.h.toDouble(),
      width: Sizes.dimen_80.w.toDouble(),
      padding: EdgeInsets.only(
        top: Sizes.dimen_2.h.toDouble(),
        bottom: Sizes.dimen_6.h.toDouble(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_1.h.toDouble())),
        gradient: LinearGradient(
          colors: [
            AppColor.violet,
            AppColor.royalBlue,
          ],
        ),
      ),
    );
  }
}


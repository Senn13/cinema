import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/screenutil/screenutil.dart';
import 'package:cinema/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MovieAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil.statusBarHeight + Sizes.dimen_4.h,
        left: Sizes.dimen_16.w.toDouble(),
        right: Sizes.dimen_16.w.toDouble(),
      ),
      child: Row(
        children: <Widget> [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              'assets/svgs/menu.svg',
              height: Sizes.dimen_12.h.toDouble(),
            ),
          ),
          Expanded(
            child: Logo(
              height: Sizes.dimen_14,
              key: UniqueKey(), // Replace null with a unique key
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: Sizes.dimen_12.h.toDouble(),
            ),
          ),
        ],
      ),
    );
  }
}
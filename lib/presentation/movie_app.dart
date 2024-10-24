import 'package:cinema/common/screenutil/screenutil.dart';
import 'package:cinema/presentation/journeys/home/home_screen.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:flutter/material.dart';

class MovieApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: HomeScreen(),
    );
  }
}
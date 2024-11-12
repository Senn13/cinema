import 'package:cinema/common/constants/languages.dart';
import 'package:cinema/common/screenutil/screenutil.dart';
import 'package:cinema/presentation/app_localizations.dart';
import 'package:cinema/presentation/journeys/home/home_screen.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MovieApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
            secondary: AppColor.royalBlue,
          ),
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      supportedLocales: Languages.languages.map((e) => Locale(e.code)).toList(),
      locale: Locale(Languages.languages[0].code),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomeScreen(),
    );
  }
}
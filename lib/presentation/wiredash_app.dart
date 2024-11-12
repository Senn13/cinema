import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class WiredashApp extends StatelessWidget {
  final Widget child;
  final String languageCode;

  const WiredashApp({
    Key? key,
    required this.child,
    required this.languageCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'cinema-vop93ko',
      secret: 'UbfqbeKvJYusXzFuxIDLXsIkIBVZsjqg',
      child: child,
      options: WiredashOptionsData(
        locale: Locale.fromSubtags(
          languageCode: languageCode,
        ),
      ),
      theme: WiredashThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColor.royalBlue,
        secondaryColor: AppColor.violet,
      )
    );
  }
}
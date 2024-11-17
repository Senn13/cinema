import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [AppColor.royalBlue, AppColor.violet]
              : [Colors.grey, Colors.grey],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.dimen_20.w.toDouble()),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w.toDouble()),
      margin: EdgeInsets.symmetric(vertical: Sizes.dimen_10.h.toDouble()),
      height: Sizes.dimen_16.h.toDouble(),
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        child: Text(
          text.t(context),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
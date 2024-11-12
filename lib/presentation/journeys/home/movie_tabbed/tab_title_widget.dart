import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/app_localizations.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:flutter/material.dart';

class TabTitleWidget extends StatelessWidget{
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const TabTitleWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  })  : assert(title != null, 'title should not be null'),
        assert(onTap != null, 'onTap should not be null'),
        assert(isSelected != null, 'isSelected should not be null'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColor.royalBlue : Colors.transparent,
              width: Sizes.dimen_1.h.toDouble(),
            ),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)?.translate(title) ?? 'Default Title',
          style: isSelected
              ? Theme.of(context).textTheme.royalBlueSubtitle1
              : Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
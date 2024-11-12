import 'package:cinema/common/constants/languages.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/app_localizations.dart';
import 'package:cinema/presentation/journeys/drawer/navigation_expanded_list_item.dart';
import 'package:cinema/presentation/journeys/drawer/navigation_list_item.dart';
import 'package:cinema/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget{
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            blurRadius: 4,
          )
        ]
      ),
      width: Sizes.dimen_300.w.toDouble(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Sizes.dimen_8.h.toDouble(),
                bottom: Sizes.dimen_18.h.toDouble(),
                left: Sizes.dimen_8.h.toDouble(),
                right: Sizes.dimen_8.h.toDouble(),
              ),
              child: Logo(
                height: Sizes.dimen_20.h.toDouble(),
              )
            ),
            NavigationListItem(
              title: AppLocalizations.of(context)
                  ?.translate(TranslationConstants.favoriteMovies) ?? 'Default Title',
              onPressed: () {},
            ),
            NavigationExpandedListItem(
              title: AppLocalizations.of(context)
                  ?.translate(TranslationConstants.language) ?? 'Default Language',
              onPressed: () {},
              children: Languages.languages.map((e) => e.value).toList(),
            ),
            NavigationListItem(
              title: AppLocalizations.of(context)
                  ?.translate(TranslationConstants.feedback) ?? 'Default Feedback',
              onPressed: () {},
            ),
            NavigationListItem(
              title: AppLocalizations.of(context)
                  ?.translate(TranslationConstants.about) ?? 'Default About',
              onPressed: () {},
            ),
          ],
        )
      )
    );
  }
}
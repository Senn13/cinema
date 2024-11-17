import 'package:cinema/common/constants/languages.dart';
import 'package:cinema/common/constants/route_constants.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/presentation/blocs/language/language_bloc.dart';
import 'package:cinema/presentation/blocs/login/login_bloc.dart';
import 'package:cinema/presentation/journeys/drawer/navigation_expanded_list_item.dart';
import 'package:cinema/presentation/journeys/drawer/navigation_list_item.dart';
import 'package:cinema/presentation/journeys/favorite/favorite_screen.dart';
import 'package:cinema/presentation/widgets/app_dialog.dart';
import 'package:cinema/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiredash/wiredash.dart';

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
              title: TranslationConstants.favoriteMovies.t(context) ,
              onPressed: () {
                Navigator.of(context).pushNamed(RouteList.favorite);
              },
            ),
            NavigationExpandedListItem(
              title: TranslationConstants.language.t(context),
              children: Languages.languages.map((e) => e.value).toList(),
              onPressed: (index) {
                BlocProvider.of<LanguageBloc>(context).add(
                  ToggleLanguageEvent(Languages.languages[index]),
                );
              },
            ),
            NavigationListItem(
              title: TranslationConstants.feedback.t(context),
              onPressed: () {
                Navigator.of(context).pop();
                Wiredash.of(context).show();
              },
            ),
            NavigationListItem(
              title: TranslationConstants.about.t(context),
              onPressed: () {
                Navigator.of(context).pop();
                _showDialog(context);
              },
            ),
            BlocListener<LoginBloc, LoginState>(
              listenWhen: (previous, current) => current is LogoutSuccess,
              listener: (context, state) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteList.initial, (route) => false);
              },
              child: NavigationListItem(
                title: TranslationConstants.logout.t(context),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(LogoutEvent());
                },
              ),
            ),
          ],
        )
      )
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        title: TranslationConstants.about,
        description: TranslationConstants.aboutDescription,
        buttonText: TranslationConstants.okay,
        image: Image.asset(
          'assets/pngs/tmdb_logo.png',
          height: Sizes.dimen_32.h.toDouble(),
        ),
      );
    },
  );
}




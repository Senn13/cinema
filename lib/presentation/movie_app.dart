import 'package:cinema/common/constants/languages.dart';
import 'package:cinema/common/constants/route_constants.dart';
import 'package:cinema/common/screenutil/screenutil.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/presentation/app_localizations.dart';
import 'package:cinema/presentation/blocs/language/language_bloc.dart';
import 'package:cinema/presentation/blocs/login/login_bloc.dart';
import 'package:cinema/presentation/fade_page_route_builder.dart';
import 'package:cinema/presentation/routes.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:cinema/presentation/wiredash_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  late LanguageBloc _languageBloc;

  @override
  void initState() {
    super.initState();
    _languageBloc = getItInstance<LanguageBloc>();
    _languageBloc.add(LoadPreferredLanguageEvent());
  }

  @override
  void dispose() {
    _languageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>.value(
          value: _languageBloc,
        ),
        BlocProvider<LoginBloc>(
          create: (context) => getItInstance<LoginBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          if (state is LanguageLoaded) {
            return WiredashApp(
              languageCode: state.locale.languageCode,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Movie App',
                theme: ThemeData(
                  unselectedWidgetColor: AppColor.royalBlue,
                  primaryColor: AppColor.vulcan,
                  accentColor: AppColor.royalBlue,
                  scaffoldBackgroundColor: AppColor.vulcan,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: ThemeText.getTextTheme(),
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    backgroundColor: AppColor.vulcan,
                    iconTheme: IconThemeData(color: Colors.white,),
                  ),
                ),
                supportedLocales:
                    Languages.languages.map((e) => Locale(e.code)).toList(),
                locale: state.locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                builder: (context, child) {
                  return child!;
                },
                initialRoute: RouteList.initial,
                onGenerateRoute: (RouteSettings settings) {
                  final routes = Routes.getRoutes(settings);
                  final WidgetBuilder? builder = routes[settings.name];

                  if (builder != null) {
                    return FadePageRouteBuilder(
                      builder: builder,
                      settings: settings,
                    );
                  }
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
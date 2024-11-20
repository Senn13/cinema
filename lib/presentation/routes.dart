import 'package:cinema/common/constants/route_constants.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:cinema/presentation/journeys/favorite/favorite_screen.dart';
import 'package:cinema/presentation/journeys/home/home_screen.dart';
import 'package:cinema/presentation/journeys/login/login_screen.dart';
import 'package:cinema/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:cinema/presentation/journeys/movie_detail/movie_detail_screen.dart';
import 'package:cinema/presentation/journeys/tickets/my_tickets_screen.dart';
import 'package:cinema/presentation/journeys/watch_video/watch_video_argruments.dart';
import 'package:cinema/presentation/journeys/watch_video/watch_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => LoginScreen(),
        RouteList.home: (context) => HomeScreen(),
        RouteList.movieDetail: (context) => MovieDetailScreen(
              movieDetailArguments: setting.arguments as MovieDetailArguments,
            ),
        RouteList.watchTrailer: (context) => WatchVideoScreen(
              watchVideoArguments: setting.arguments as WatchVideoArguments,
            ),
        RouteList.favorite: (context) => FavoriteScreen(),
        RouteList.myTickets: (context) => BlocProvider<BookingBloc>(
      create: (context) => getItInstance<BookingBloc>(),
      child: const MyTicketsScreen(),
    ),
      };
}

import 'package:cinema/data/tables/movie_table.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:cinema/presentation/movie_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pedantic/pedantic.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'di/get_it.dart' as getIt;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(MovieTableAdapter());
  unawaited(getIt.init());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BookingBloc>(
          create: (_) => getIt.getItInstance<BookingBloc>(),
        ),
        // Other BlocProviders...
      ],
      child: MovieApp(),
    ),
  );
}


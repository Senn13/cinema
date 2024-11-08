import 'package:cinema/data/data_sources/movie_remote_data_source.dart';
import 'package:cinema/data/repositories/movie_repository_impl.dart';
import 'package:cinema/domain/repositories/movie_repository.dart';
import 'package:cinema/domain/usecases/get_coming_soon.dart';
import 'package:cinema/domain/usecases/get_playing_now.dart';
import 'package:cinema/domain/usecases/get_popular.dart';
import 'package:cinema/domain/usecases/get_trending.dart';
import 'package:cinema/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:cinema/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:cinema/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:cinema/data/core/api_client.dart';

final getItInstance = GetIt.I;

Future init() async {

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<Client>(
    () => Client());

  getItInstance.registerLazySingleton<ApiClient>(
    () => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<GetTrending>(
    () => GetTrending(getItInstance()));

  getItInstance.registerLazySingleton<GetPopular>(
    () => GetPopular(getItInstance()));

  getItInstance.registerLazySingleton<GetPlayingNow>(
    () => GetPlayingNow(getItInstance()));

  getItInstance.registerLazySingleton<GetComingSoon>(
    () => GetComingSoon(getItInstance()));  

  getItInstance.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getItInstance()));

  getItInstance.registerFactory(() => MovieBackdropBloc());

  getItInstance.registerFactory(
    () => MovieCarouselBloc(
        getTrending: getItInstance(),
        movieBackdropBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieTabbedBloc(
        getPopular: GetPopular(getItInstance()), 
        getPlayingNow: GetPlayingNow(getItInstance()), 
        getComingSoon: GetComingSoon(getItInstance()),
    )
  );
}
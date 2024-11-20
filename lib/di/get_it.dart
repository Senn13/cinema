import 'package:cinema/data/data_sources/authentication_local_data_source.dart';
import 'package:cinema/data/data_sources/authentication_remote_data_source.dart';
import 'package:cinema/data/data_sources/language_local_data_source.dart';
import 'package:cinema/data/data_sources/movie_local_data_source.dart';
import 'package:cinema/data/data_sources/movie_remote_data_source.dart';
import 'package:cinema/data/data_sources/booking_remote_data_source.dart';
import 'package:cinema/data/repositories/app_repository_impl.dart';
import 'package:cinema/data/repositories/authentication_repository_impl.dart';
import 'package:cinema/data/repositories/movie_repository_impl.dart';
import 'package:cinema/data/repositories/booking_repository_impl.dart';
import 'package:cinema/domain/repositories/app_repository.dart';
import 'package:cinema/domain/repositories/authentication_repository.dart';
import 'package:cinema/domain/repositories/movie_repository.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/domain/usecases/check_if_movie_favorite.dart';
import 'package:cinema/domain/usecases/delete_favorite_movie.dart';
import 'package:cinema/domain/usecases/get_cast.dart';
import 'package:cinema/domain/usecases/get_coming_soon.dart';
import 'package:cinema/domain/usecases/get_favorite_movies.dart';
import 'package:cinema/domain/usecases/get_movie_detail.dart';
import 'package:cinema/domain/usecases/get_playing_now.dart';
import 'package:cinema/domain/usecases/get_popular.dart';
import 'package:cinema/domain/usecases/get_preferred_language.dart';
import 'package:cinema/domain/usecases/get_trending.dart';
import 'package:cinema/domain/usecases/get_videos.dart';
import 'package:cinema/domain/usecases/login_user.dart';
import 'package:cinema/domain/usecases/logout_user.dart';
import 'package:cinema/domain/usecases/save_movie.dart';
import 'package:cinema/domain/usecases/search_movies.dart';
import 'package:cinema/domain/usecases/update_language.dart';
import 'package:cinema/domain/usecases/get_showtime.dart';
import 'package:cinema/domain/usecases/process_payment.dart';
import 'package:cinema/domain/usecases/get_user_tickets.dart';
import 'package:cinema/presentation/blocs/cast/cast_bloc.dart';
import 'package:cinema/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:cinema/presentation/blocs/language/language_bloc.dart';
import 'package:cinema/presentation/blocs/login/login_bloc.dart';
import 'package:cinema/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:cinema/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:cinema/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:cinema/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:cinema/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:cinema/presentation/blocs/showtimes/showtimes_bloc.dart';
import 'package:cinema/presentation/blocs/videos/videos_bloc.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:cinema/data/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinema/data/data_sources/ticket_local_data_source.dart';


final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl());

  getItInstance.registerLazySingleton<LanguageLocalDataSource>(
      () => LanguageLocalDataSourceImpl());

  getItInstance.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationLocalDataSource>(
      () => AuthenticationLocalDataSourceImpl());


  getItInstance.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(getItInstance()),
  );

  getItInstance.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getItInstance(), getItInstance()),
  );

  getItInstance.registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
  getItInstance
      .registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
  getItInstance.registerLazySingleton<GetPlayingNow>(
      () => GetPlayingNow(getItInstance()));
  getItInstance.registerLazySingleton<GetComingSoon>(
      () => GetComingSoon(getItInstance()));

  getItInstance.registerLazySingleton<GetMovieDetail>(
      () => GetMovieDetail(getItInstance()));

  getItInstance.registerLazySingleton<GetCast>(() => GetCast(getItInstance()));

  getItInstance
      .registerLazySingleton<SearchMovies>(() => SearchMovies(getItInstance()));

  getItInstance
      .registerLazySingleton<GetVideos>(() => GetVideos(getItInstance()));

  getItInstance
      .registerLazySingleton<SaveMovie>(() => SaveMovie(getItInstance()));

  getItInstance.registerLazySingleton<GetFavoriteMovies>(
      () => GetFavoriteMovies(getItInstance()));

  getItInstance.registerLazySingleton<DeleteFavoriteMovie>(
      () => DeleteFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<CheckIfFavoriteMovie>(
      () => CheckIfFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<UpdateLanguage>(
      () => UpdateLanguage(getItInstance()));

  getItInstance.registerLazySingleton<GetPreferredLanguage>(
      () => GetPreferredLanguage(getItInstance()));

  getItInstance.registerLazySingleton<LoginUser>(
      () => LoginUser(getItInstance()));

  getItInstance.registerLazySingleton<LogoutUser>(
      () => LogoutUser(getItInstance()));

  getItInstance
      .registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
            getItInstance(),
            getItInstance(),
          ));

  getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(
        getItInstance(),
      ));

  getItInstance.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
            getItInstance(),
            getItInstance(),
          ));

  getItInstance.registerFactory(() => MovieBackdropBloc());

  getItInstance.registerFactory(
    () => MovieCarouselBloc(
      getTrending: getItInstance(),
      movieBackdropBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieTabbedBloc(
      getPopular: getItInstance(),
      getComingSoon: getItInstance(),
      getPlayingNow: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: getItInstance(),
      castBloc: getItInstance(),
      videosBloc: getItInstance(),
      favoriteBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => CastBloc(
      getCast: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => VideosBloc(
      getVideos: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => SearchMovieBloc(
      searchMovies: getItInstance(),
    ),
  );

  getItInstance.registerSingleton<LanguageBloc>(LanguageBloc(
    updateLanguage: getItInstance(),
    getPreferredLanguage: getItInstance(),
  ));

  getItInstance.registerFactory(() => FavoriteBloc(
        saveMovie: getItInstance(),
        checkIfFavoriteMovie: getItInstance(),
        deleteFavoriteMovie: getItInstance(),
        getFavoriteMovies: getItInstance(),
      ));

  getItInstance.registerFactory(() => LoginBloc(
        loginUser: getItInstance(),
        logoutUser: getItInstance(),
      ));

  // getItInstance.registerFactory(
  //   () => BookingBloc(
  //     getShowtimes: getItInstance(),
  //     processPayment: getItInstance(),
  //   ),
  // );

  getItInstance.registerLazySingleton(() => GetShowtimes(getItInstance()));
  getItInstance.registerLazySingleton(() => ProcessPayment(getItInstance()));

  getItInstance.registerLazySingleton<GetUserTickets>(
    () => GetUserTickets(getItInstance<BookingRepository>()),
  );

  // Add SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  getItInstance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Đăng ký ShowtimesBloc
  getItInstance.registerFactory(
    () => ShowtimesBloc(
      remoteDataSource: getItInstance<BookingRemoteDataSource>(),
    ),
  );

  getItInstance.registerLazySingleton<TicketLocalDataSource>(
    () => TicketLocalDataSource(sharedPreferences),
  );

  getItInstance.registerFactory(
    () => BookingBloc(getItInstance()),
  );
}
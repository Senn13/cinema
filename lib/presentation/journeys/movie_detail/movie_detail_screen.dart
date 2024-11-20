import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/blocs/cast/cast_bloc.dart';
import 'package:cinema/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:cinema/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:cinema/presentation/blocs/videos/videos_bloc.dart';
import 'package:cinema/presentation/journeys/booking/booking_screen.dart';
import 'package:cinema/presentation/journeys/movie_detail/big_poster.dart';
import 'package:cinema/presentation/journeys/movie_detail/cast_widget.dart';
import 'package:cinema/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:cinema/presentation/journeys/movie_detail/videos_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetailArguments movieDetailArguments;

  const MovieDetailScreen({
    Key? key,
    required this.movieDetailArguments,
  })  : assert(movieDetailArguments != null, 'arguments must not be null'),
        super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieDetailBloc _movieDetailBloc;
  late CastBloc _castBloc;
  late VideosBloc _videosBloc;
  late FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _movieDetailBloc = getItInstance<MovieDetailBloc>();
    _castBloc = _movieDetailBloc.castBloc;
    _videosBloc = _movieDetailBloc.videosBloc;
    _favoriteBloc = _movieDetailBloc.favoriteBloc;
    _movieDetailBloc.add(
      MovieDetailLoadEvent(
        widget.movieDetailArguments.movieId,
      ),
    );
  }

  @override
  void dispose() {
    _movieDetailBloc?.close();
    _castBloc?.close();
    _videosBloc?.close();
    _favoriteBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _movieDetailBloc),
          BlocProvider.value(value: _castBloc),
          BlocProvider.value(value: _videosBloc),
          BlocProvider.value(value: _favoriteBloc),
        ],
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoaded) {
              final movieDetail = state.movieDetailEntity;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BigPoster(
                      movie: movieDetail,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.dimen_16.w.toDouble(),
                        vertical: Sizes.dimen_8.h.toDouble(),
                      ),
                      child: Text(
                        movieDetail.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w.toDouble()),
                      child: Text(
                        TranslationConstants.cast.t(context),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    CastWidget(),
                    VideosWidget(videosBloc: _videosBloc),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(movie: MovieEntity(
                              id: movieDetail.id,
                              title: movieDetail.title,
                              posterPath: movieDetail.posterPath,
                              backdropPath: movieDetail.backdropPath,
                            )),
                          ),
                        );
                      },
                      child: Text('Book Tickets'),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailError) {
              return Container();
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
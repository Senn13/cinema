import 'package:bloc/bloc.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/movie_params.dart';
import 'package:cinema/domain/entities/video_entity.dart';
import 'package:cinema/domain/usecases/get_videos.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final GetVideos getVideos;

  VideosBloc({
    required this.getVideos,
  }) : super(VideosInitial());

  @override
  Stream<VideosState> mapEventToState(
    VideosEvent event,
  ) async* {
    if (event is LoadVideosEvent) {
      final Either<AppError, List<VideoEntity>> videosEither =
          await getVideos(MovieParams(event.movieId));

      yield videosEither.fold(
        (l) {
          print('Videos Error: $l');
          return NoVideos();
        },
        (videos) {
          print('Videos Loaded: ${videos.length}');
          return VideosLoaded(videos);
        },
      );
    }
  }
}

import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/cast_entity.dart';
import 'package:cinema/domain/entities/movie_detail_entity.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/domain/entities/video_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository {
  Future<Either<AppError, List<MovieEntity>>> getTrending();
  Future<Either<AppError, List<MovieEntity>>> getPopular();
  Future<Either<AppError, List<MovieEntity>>> getPlayingNow();
  Future<Either<AppError, List<MovieEntity>>> getComingSoon();
  Future<Either<AppError, MovieDetailEntity>> getMovieDetail(int id);
  Future<Either<AppError, List<CastEntity>>> getCastCrew(int id);
  Future<Either<AppError, List<VideoEntity>>> getVideos(int id);
  Future<Either<AppError, List<MovieEntity>>> getSearchedMovies(String searchTerm);
  Future<Either<AppError, void>> saveMovie(MovieEntity movieEntity);
  Future<Either<AppError, List<MovieEntity>>> getFavoriteMovies();
  Future<Either<AppError, void>> deleteFavoriteMovie(int movieId);
  Future<Either<AppError, bool>> checkIfMovieFavorite(int movieId);
}

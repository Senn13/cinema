import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/domain/entities/movie_search_params.dart';
import 'package:cinema/domain/repositories/movie_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class SearchMovies extends UseCase<List<MovieEntity>, MovieSearchParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<AppError, List<MovieEntity>>> call(MovieSearchParams searchParams) async {
    return await repository.getSearchedMovies(searchParams.searchTerm);
  } 
}
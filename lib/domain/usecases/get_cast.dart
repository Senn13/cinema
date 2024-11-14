import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/cast_entity.dart';
import 'package:cinema/domain/entities/movie_params.dart';
import 'package:cinema/domain/repositories/movie_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class GetCast extends UseCase<List<CastEntity>, MovieParams> {
  final MovieRepository repository;

  GetCast(this.repository);

  @override
  Future<Either<AppError, List<CastEntity>>> call(MovieParams movieParams) async {
    return await repository.getCastCrew(movieParams.id);
  } 
}
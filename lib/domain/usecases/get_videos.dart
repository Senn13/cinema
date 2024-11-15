import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/movie_params.dart';
import 'package:cinema/domain/entities/video_entity.dart';
import 'package:cinema/domain/repositories/movie_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class GetVideos extends UseCase<List<VideoEntity>, MovieParams> {
  final MovieRepository repository;

  GetVideos(this.repository);

  @override
  Future<Either<AppError, List<VideoEntity>>> call(MovieParams movieParams) async {
    return await repository.getVideos(movieParams.id);
  } 
}
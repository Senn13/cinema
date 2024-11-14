import 'package:bloc/bloc.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/cast_entity.dart';
import 'package:cinema/domain/entities/movie_params.dart';
import 'package:cinema/domain/usecases/get_cast.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'cast_event.dart';
part 'cast_state.dart';

class CastBloc extends Bloc<CastEvent, CastState> {
  final GetCast getCast;

  CastBloc({required this.getCast}) : super(CastInitial());

  @override
  Stream<CastState> mapEventToState(
    CastEvent event,
  ) async* {
    if (event is LoadCastEvent) {
      Either<AppError, List<CastEntity>> eitherResponse =
          await getCast(MovieParams(event.movieId));

      yield eitherResponse.fold(
        (l) => CastError(),
        (r) => CastLoaded(casts: r),
      );
    }
  }
}
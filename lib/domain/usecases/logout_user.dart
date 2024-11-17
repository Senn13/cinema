import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/no_params.dart';
import 'package:cinema/domain/repositories/authentication_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class LogoutUser extends UseCase<void, NoParams> {
  final AuthenticationRepository _authenticationRepository;

  LogoutUser(this._authenticationRepository);

  @override
  Future<Either<AppError, void>> call(NoParams noParams) async =>
      _authenticationRepository.logoutUser();
}
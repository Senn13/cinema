import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/login_request_params.dart';
import 'package:cinema/domain/repositories/authentication_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class LoginUser extends UseCase<bool, LoginRequestParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUser(this._authenticationRepository);

  @override
  Future<Either<AppError, bool>> call(LoginRequestParams params) async =>
      _authenticationRepository.loginUser(params.toJson());
}
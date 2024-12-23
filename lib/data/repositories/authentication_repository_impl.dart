import 'dart:io';

import 'package:cinema/data/core/unathorised_exception.dart';
import 'package:cinema/data/data_sources/authentication_local_data_source.dart';
import 'package:cinema/data/data_sources/authentication_remote_data_source.dart';
import 'package:cinema/data/models/request_token_model.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  AuthenticationRepositoryImpl(
    this._authenticationRemoteDataSource,
    this._authenticationLocalDataSource,
  );

  Future<Either<AppError, RequestTokenModel>> _getRequestToken() async {
    try {
      final response = await _authenticationRemoteDataSource.getRequestToken();
      return Right(response);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, bool>> loginUser(Map<String, dynamic> body) async {
  final requestTokenEitherResponse = await _getRequestToken();

  final token1 = requestTokenEitherResponse.fold(
    (error) => null,
    (requestTokenModel) => requestTokenModel.requestToken,
  );

  if (token1 == null || token1.isEmpty) {
    return Left(AppError(AppErrorType.api));
  }

  try {
    body.putIfAbsent('request_token', () => token1);

    final validateWithLoginToken =
        await _authenticationRemoteDataSource.validateWithLogin(body);

    final sessionId = await _authenticationRemoteDataSource
        .createSession(validateWithLoginToken.toJson());

    if (sessionId.isEmpty) {
      return Left(AppError(AppErrorType.sessionDenied));
    }
    
    await _authenticationLocalDataSource.saveSessionId(sessionId);
    return Right(true);
  } on SocketException {
    return Left(AppError(AppErrorType.network));
  } on UnauthorisedException {
    return Left(AppError(AppErrorType.unauthorised));
  } catch (e) {
    return Left(AppError(AppErrorType.api));
  }
}


  @override
  Future<Either<AppError, void>> logoutUser() async {
    try {
      final sessionId = await _authenticationLocalDataSource.getSessionId();
      
      if (sessionId != null) {
        try {
          await _authenticationRemoteDataSource.deleteSession(sessionId);
        } catch (e) {
          print('Error deleting remote session: $e');
          // Continue to delete local session even if remote fails
        }
      }
      
      await _authenticationLocalDataSource.deleteSessionId();
      return const Right(unit);
      
    } catch (e) {
      print('Logout error: $e');
      return Left(AppError(AppErrorType.database));
    }
  }
}
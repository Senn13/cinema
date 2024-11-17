import 'package:cinema/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';

abstract class AppRepository {
  Future<Either<AppError, void>> updateLanguage(String language);
  Future<Either<AppError, String>> getPreferredLanguage();
}
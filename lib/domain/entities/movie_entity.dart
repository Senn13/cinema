import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String posterPath;
  final int id;
  final String? backdropPath;
  final String title;
  final num? voteAverage;
  final String? releaseDate;
  final String overview;

  const MovieEntity({
    required this.posterPath,
    required this.id,
    this.backdropPath,
    required this.title,
    this.voteAverage,
    this.releaseDate,
    required this.overview,
  }) : assert(id != null, 'Movie id must not be null');

  @override
  List<Object> get props => [id, title];

  @override
  bool get stringify => true;
}

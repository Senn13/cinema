import 'package:cinema/domain/entities/movie_entity.dart';


class MovieModel extends MovieEntity {
  final int id;
  final bool video;
  final int voteCount;
  final double voteAverage;
  final String title;
  final String releaseDate; // Nullable
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String backdropPath; // Make non-nullable
  final bool adult;
  final String overview;
  final String posterPath; // Make non-nullable
  final double popularity;
  final String? mediaType; // Nullable

  MovieModel({
    required this.id,
    required this.video,
    required this.voteCount,
    required this.voteAverage,
    required this.title,
    required this.releaseDate,
    required this.originalLanguage,
    required this.originalTitle,
    required this.genreIds,
    required this.backdropPath, // Non-nullable
    required this.adult,
    required this.overview,
    required this.posterPath, // Non-nullable
    required this.popularity,
    this.mediaType,
  }) : super(
          id: id,
          title: title,
          backdropPath: backdropPath, // Pass as non-nullable
          posterPath: posterPath, // Pass as non-nullable
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          overview: overview,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0, // Required positional argument
      video: json['video'] ?? false, // Required positional argument
      voteCount: json['vote_count'] ?? 0, // Required positional argument
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0, // Handle double conversion safely
      title: json['title'] ?? 'Untitled', // Default to 'Untitled' if title is null
      releaseDate: json['release_date'] as String, // Nullable field
      originalLanguage: json['original_language'] ?? 'Unknown', // Default if missing
      originalTitle: json['original_title'] ?? 'Unknown Title', // Default if missing
      genreIds: (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [], // Handle list safely
      backdropPath: json['backdrop_path'] ?? '', // Provide default for non-nullable field
      adult: json['adult'] ?? false, // Default to false if missing
      overview: json['overview'] ?? 'No overview available', // Provide default overview
      posterPath: json['poster_path'] ?? '', // Provide default for non-nullable field
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0, // Handle double conversion
      mediaType: json['media_type'] as String?, // Nullable field
    );
  }

  toJson() {}

  static fromEntity(MovieEntity entity) {}
}





import 'package:cinema/domain/entities/cast_entity.dart';

class CastCrewResultModel {
  int? id;
  List<CastModel>? cast;
  List<Crew>? crew;

  CastCrewResultModel({this.id, this.cast, this.crew});

  CastCrewResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    if (json['cast'] != null && json['cast'] is List) {
      cast = (json['cast'] as List)
          .map((v) => CastModel.fromJson(v))
          .toList();
    }

    if (json['crew'] != null && json['crew'] is List) {
      crew = (json['crew'] as List)
          .map((v) => Crew.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cast': cast?.map((v) => v.toJson()).toList(),
        'crew': crew?.map((v) => v.toJson()).toList(),
      };
}

class CastModel extends CastEntity {
  final int? castId;
  final String character;
  final String creditId;
  final int? gender;
  final int? id;
  final String name;
  final int? order;
  final String profilePath;

  CastModel({
    this.castId,
    required this.character,
    required this.creditId,
    this.gender,
    this.id,
    required this.name,
    this.order,
    required this.profilePath,
  }) : super(
          creditId: creditId,
          name: name,
          posterPath: profilePath,
          character: character,
        );

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      castId: json['cast_id'],
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      gender: json['gender'],
      id: json['id'],
      name: json['name'] ?? '',
      order: json['order'],
      profilePath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cast_id': castId,
        'character': character,
        'credit_id': creditId,
        'gender': gender,
        'id': id,
        'name': name,
        'order': order,
        'profile_path': profilePath,
      };
}

class Crew {
  final String creditId;
  final String department;
  final int? gender;
  final int? id;
  final String job;
  final String name;
  final String profilePath;

  Crew({
    required this.creditId,
    required this.department,
    this.gender,
    this.id,
    required this.job,
    required this.name,
    required this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      creditId: json['credit_id'] ?? '',
      department: json['department'] ?? '',
      gender: json['gender'],
      id: json['id'],
      job: json['job'] ?? '',
      name: json['name'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'credit_id': creditId,
        'department': department,
        'gender': gender,
        'id': id,
        'job': job,
        'name': name,
        'profile_path': profilePath,
      };
}

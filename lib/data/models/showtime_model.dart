import 'package:equatable/equatable.dart';

class ShowtimeModel extends Equatable {
  final int id;
  final int movieId;
  final String movieTitle;
  final String posterPath;
  final DateTime showDate;
  final String time;
  final double price;
  final String screenType;

  const ShowtimeModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterPath,
    required this.showDate,
    required this.time,
    required this.price,
    required this.screenType,
  });

  @override
  List<Object> get props => [
        id,
        movieId,
        movieTitle,
        posterPath,
        showDate,
        time,
        price,
        screenType,
      ];

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) {
    return ShowtimeModel(
      id: json['id'] as int,
      movieId: json['movieId'] as int,
      movieTitle: json['movieTitle'] as String,
      posterPath: json['posterPath'] as String,
      showDate: DateTime.parse(json['showDate'] as String),
      time: json['time'] as String,
      price: (json['price'] as num).toDouble(),
      screenType: json['screenType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterPath': posterPath,
      'showDate': showDate.toIso8601String(),
      'time': time,
      'price': price,
      'screenType': screenType,
    };
  }
}
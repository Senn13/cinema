import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class AuthenticationLocalDataSource {
  Future<void> saveSessionId(String sessionId);
  Future<String> getSessionId();
  Future<void> deleteSessionId();
  Future<void> saveLoginCredentials(String username, String password);
  Future<void> clearLoginCredentials();
  Future<Map<String, String>?> getLoginCredentials();
}

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  final SharedPreferences _preferences;

  AuthenticationLocalDataSourceImpl(this._preferences);

  @override
  Future<void> deleteSessionId() async {
    print('delete session - local');
    final authenticationBox = await Hive.openBox('authenticationBox');
    authenticationBox.delete('session_id');
  }

  @override
  Future<String> getSessionId() async {
    final authenticationBox = await Hive.openBox('authenticationBox');
    return await authenticationBox.get('session_id');
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    final authenticationBox = await Hive.openBox('authenticationBox');
    return await authenticationBox.put('session_id', sessionId);
  }

  @override
  Future<void> saveLoginCredentials(String username, String password) async {
    await _preferences.setString('username', username);
    await _preferences.setString('password', password);
    await _preferences.setBool('remember_me', true);
  }

  @override
  Future<void> clearLoginCredentials() async {
    await _preferences.remove('username');
    await _preferences.remove('password');
    await _preferences.setBool('remember_me', false);
  }

  @override
  Future<Map<String, String>?> getLoginCredentials() async {
    final rememberMe = _preferences.getBool('remember_me') ?? false;
    if (!rememberMe) return null;

    final username = _preferences.getString('username');
    final password = _preferences.getString('password');
    
    if (username != null && password != null) {
      return {
        'username': username,
        'password': password,
      };
    }
    return null;
  }
}

class SeatBookingInfo {
  final String seatNumber;
  final int showtimeId;
  final DateTime bookingTime;

  SeatBookingInfo({
    required this.seatNumber,
    required this.showtimeId,
    required this.bookingTime,
  });

  Map<String, dynamic> toJson() => {
    'seatNumber': seatNumber,
    'showtimeId': showtimeId,
    'bookingTime': bookingTime.toIso8601String(),
  };

  factory SeatBookingInfo.fromJson(Map<String, dynamic> json) => SeatBookingInfo(
    seatNumber: json['seatNumber'],
    showtimeId: json['showtimeId'],
    bookingTime: DateTime.parse(json['bookingTime']),
  );
}

class SeatLocalDataSource {
  static const String KEY_BOOKED_SEATS = 'booked_seats';
  final SharedPreferences _prefs;

  SeatLocalDataSource(this._prefs);

  Future<void> saveBookedSeats(List<String> seats, int showtimeId) async {
    final currentBookings = await getValidBookedSeats(showtimeId);
    
    final newBookings = seats.map((seat) => SeatBookingInfo(
      seatNumber: seat,
      showtimeId: showtimeId,
      bookingTime: DateTime.now(),
    )).toList();

    currentBookings.addAll(newBookings);
    
    final bookingsJson = currentBookings.map((b) => b.toJson()).toList();
    await _prefs.setString(KEY_BOOKED_SEATS, jsonEncode(bookingsJson));
  }

  Future<List<SeatBookingInfo>> getValidBookedSeats(int showtimeId) async {
    final bookingsString = _prefs.getString(KEY_BOOKED_SEATS);
    if (bookingsString == null) return [];

    final bookingsJson = jsonDecode(bookingsString) as List;
    final allBookings = bookingsJson
        .map((json) => SeatBookingInfo.fromJson(json))
        .where((booking) {
          final bookingAge = DateTime.now().difference(booking.bookingTime);
          return bookingAge.inHours < 24 && booking.showtimeId == showtimeId;
        })
        .toList();

    // Lưu lại danh sách đã lọc
    final validBookingsJson = allBookings.map((b) => b.toJson()).toList();
    await _prefs.setString(KEY_BOOKED_SEATS, jsonEncode(validBookingsJson));

    return allBookings;
  }
}
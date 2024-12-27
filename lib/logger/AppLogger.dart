import 'package:logger/logger.dart';

class AppLogger {
  //private constructor
  AppLogger._internal();

  // static instance
  static final AppLogger _instance = AppLogger._internal();

// Public factory method
  factory AppLogger() => _instance;

  // Logger instance
  final Logger _logger = Logger();

  // Public logging methods
  void debug(String message) => _logger.d(message);

  void info(String message) => _logger.i(message);

  void warning(String message) => _logger.w(message);

  void error(String message) => _logger.e(message);
}

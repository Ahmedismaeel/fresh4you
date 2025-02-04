import 'dart:developer' as developer;

extension StringLogging on String? {
  void log() {
    if (this != null) {
      developer.log(this ?? "no data");
    }
  }
}

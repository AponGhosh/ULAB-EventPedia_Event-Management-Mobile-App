import 'package:flutter/foundation.dart';

class UserRegistrationsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _registrations = [];

  List<Map<String, dynamic>> get registrations => _registrations;

  void addRegistration(Map<String, dynamic> registration) {
    _registrations.add(registration);
    notifyListeners();  // Notify listeners of changes
  }
}

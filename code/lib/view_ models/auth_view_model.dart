import 'package:air_guard/domain/models/user.dart';
import 'package:air_guard/repository/firestore/user_repo.dart';
import 'package:air_guard/services/auth_service.dart';
import 'package:air_guard/services/results.dart';
import 'package:air_guard/views/search/search_view.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService(UserRepository());
  String? errorMessage;

  bool _isLoggedIn = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;

  Future<void> register(
      String username, String email, String password, String userType) async {
    try {
      UserResult userResult =
          await _authService.register(username, email, password, userType);
      userResult.fold(
        (error) => errorMessage = error.toString(),
        (user) => _user = user,
      );
      debugPrint('User: $_user');
      notifyListeners();
    } catch (e) {
      errorMessage = 'Unexpected error during registration: $e';
      debugPrint('Error during registration: $e');
    }
  }

  Future<void> login(String username, String password) async {
    try {
      errorMessage = null; // Clear any previous error messages
      UserResult userResult = await _authService.login(username, password);
      userResult.fold(
        (error) => errorMessage = error.toString(),
        (user) => {
          _isLoggedIn = true,
          _user = user,
        },
      );
      notifyListeners();
    } catch (e) {
      errorMessage = 'Unexpected error during login: $e';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      errorMessage = null; // Clear any previous error messages
      bool success = await _authService.logout();
      if (success) {
        _isLoggedIn = false;
        _user = null;
      } else {
        errorMessage = 'Error during logout';
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Unexpected error during logout';
      notifyListeners();
    }
  }

  // Method to navigate to SearchView
  void navigateToSearch(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SearchView()));
  }
}

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final UserService _userService = UserService();

  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    final user = await _userService.loginUser(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    final user = User(
      username: username,
      email: email,
      password: password,
      favorites: [],
      tried: [],
    );
    final success = await _userService.registerUser(user);
    if (success) {
      _currentUser = user;
      notifyListeners();
    }
    return success;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> toggleFavorite(String recipeId) async {
    if (_currentUser != null) {
      final favorites = List<String>.from(_currentUser!.favorites);
      if (favorites.contains(recipeId)) {
        favorites.remove(recipeId);
      } else {
        favorites.add(recipeId);
      }
      _currentUser = _currentUser!.copyWith(favorites: favorites);
      await _userService.updateUser(_currentUser!);
      notifyListeners();
    }
  }

  Future<void> toggleTried(String recipeId) async {
    if (_currentUser != null) {
      final tried = List<String>.from(_currentUser!.tried);
      if (tried.contains(recipeId)) {
        tried.remove(recipeId);
      } else {
        tried.add(recipeId);
      }
      _currentUser = _currentUser!.copyWith(tried: tried);
      await _userService.updateUser(_currentUser!);
      notifyListeners();
    }
  }
}
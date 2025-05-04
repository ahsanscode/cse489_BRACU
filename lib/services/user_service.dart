import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class UserService {
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<List<User>> getUsers() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        // Initialize with dummy data
        await file.writeAsString(_dummyUsersJson);
        return _parseUsers(_dummyUsersJson);
      }
      final String content = await file.readAsString();
      return _parseUsers(content);
    } catch (e) {
      return [];
    }
  }

  List<User> _parseUsers(String content) {
    final List<dynamic> json = jsonDecode(content);
    return json.map((e) => User.fromJson(e)).toList();
  }

  Future<bool> registerUser(User user) async {
    final users = await getUsers();
    if (users.any((u) => u.email == user.email)) return false; // Email exists
    users.add(user);
    final file = await _getFile();
    await file.writeAsString(jsonEncode(users.map((e) => e.toJson()).toList()));
    return true;
  }

  Future<User?> loginUser(String email, String password) async {
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u.email == email && u.password == password);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(User updatedUser) async {
    final users = await getUsers();
    final index = users.indexWhere((u) => u.email == updatedUser.email);
    if (index != -1) {
      users[index] = updatedUser;
      final file = await _getFile();
      await file.writeAsString(jsonEncode(users.map((e) => e.toJson()).toList()));
    }
  }

  // Dummy users JSON
  final String _dummyUsersJson = '''
  [
    {
      "email": "test@example.com",
      "username": "TestUser",
      "password": "password123",
      "favorites": ["1", "2"],
      "tried": ["1"]
    },
    {
      "email": "alice@example.com",
      "username": "Alice",
      "password": "alice123",
      "favorites": ["3"],
      "tried": ["2", "3"]
    }
  ]
  ''';
}
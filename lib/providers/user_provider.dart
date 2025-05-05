import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      print('Error fetching users: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    try {
      await _apiService.addUser(user);
      // Don't throw if fetchUsers fails, just log it
      try {
        await fetchUsers();
      } catch (e) {
        print('Error refreshing user list: $e');
      }
    } catch (e) {
      print('Error adding user: $e');
      rethrow; // Only rethrow if the addUser itself fails
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _apiService.deleteUser(id);
      try {
        await fetchUsers();
      } catch (e) {
        print('Error refreshing user list: $e');
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
} 
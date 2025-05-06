import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

//state management
class UserProvider with ChangeNotifier {
  //ini tu bisa nyimpen data sementara di state, with change notifier artinya dia bisa ngasih tau kalo datanya ada perubahan
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners(); // ini function bawaan changetnotifier, buat ngasih tau kalo data berubah

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
      try {
        await fetchUsers();
      } catch (e) {
        print('Error refreshing user list: $e');
      }
    } catch (e) {
      print('Error adding user: $e');
      rethrow; // Hanya melempar ulang jika addUser itu sendiri gagal
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

  Future<void> editUser(String id, User user) async {
    try {
      await _apiService.editUser(id, user);
      try {
        await fetchUsers();
      } catch (e) {
        print('Error refreshing user list: $e');
      }
    } catch (e) {
      print('Error editing user: $e');
      rethrow;
    }
  }
} 
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://be-872136705893.us-central1.run.app';

  Future<List<User>> getUsers() async {
    //janji kalo berhasil akan ngasih list user
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        print('Error fetching users: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getUsers: $e');
      rethrow;
    }
  }

  Future<void> addUser(User user) async {
    //janji kalo selese, tapi ga ngasi apa apa
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      print('Add user response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception in addUser: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete-user/$id'),
      );

      print('Delete user response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204 && response.statusCode != 201) {
        throw Exception('Failed to delete user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception in deleteUser: $e');
      rethrow;
    }
  }

  Future<void> editUser(String id, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/edit-user/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      print('Edit user response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to edit user: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception in editUser: $e');
      rethrow;
    }
  }
} 
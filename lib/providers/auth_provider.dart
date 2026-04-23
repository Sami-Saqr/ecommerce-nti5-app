import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _token;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null && _token != null;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);

      if (response.statusCode == 200) {
        final data = response.data;
        _token = data['access_token'];
        ApiService.setAuthToken(_token!);

        // Get user data
        final userResponse = await ApiService.getUserData();
        if (userResponse.statusCode == 200) {
          final userData = userResponse.data;
          _user = User(
            id: userData['id'].toString(),
            fullName: userData['full_name'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            avatarUrl: userData['avatar'],
          );
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );

      if (response.statusCode == 201) {
        final data = response.data;
        _token = data['access_token'];
        ApiService.setAuthToken(_token!);

        _user = User(
          id: data['user']['id'].toString(),
          fullName: data['user']['full_name'] ?? fullName,
          email: data['user']['email'] ?? email,
          phone: data['user']['phone'] ?? phone,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    String? avatarPath,
  }) async {
    if (_user == null || _token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.updateProfile(
        fullName: fullName,
        phone: phone,
        avatar: avatarPath,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _user = _user!.copyWith(
          fullName: data['full_name']?.toString() ?? _user!.fullName,
          phone: data['phone']?.toString() ?? _user!.phone,
          avatarUrl: data['avatar']?.toString() ?? _user!.avatarUrl,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> refreshToken() async {
    if (_token == null) return false;

    try {
      final response = await ApiService.refreshToken(_token!);

      if (response.statusCode == 200) {
        _token = response.data['access_token'];
        ApiService.setAuthToken(_token!);
        return true;
      } else {
        logout();
        return false;
      }
    } catch (e) {
      logout();
      return false;
    }
  }

  void logout() {
    _user = null;
    _token = null;
    ApiService.clearAuthToken();
    notifyListeners();
  }
}

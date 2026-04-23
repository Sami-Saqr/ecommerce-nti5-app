import 'package:dio/dio.dart';
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
            fullName: userData['name'] ?? userData['full_name'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            avatarUrl: userData['image'] ?? userData['avatar'],
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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );

      // Accept both 200 and 201 as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        // Handle both direct data and nested data structure
        final data = responseData is Map && responseData.containsKey('data') 
            ? responseData['data'] 
            : responseData;
        
        _token = data['access_token'] ?? data['token'];
        if (_token != null) {
          ApiService.setAuthToken(_token!);
        }

        // User data might be in 'user' key or directly in data
        final userData = data['user'] ?? data;
        _user = User(
          id: (userData['id'] ?? '0').toString(),
          fullName: userData['name'] ?? userData['full_name'] ?? fullName,
          email: userData['email'] ?? email,
          phone: userData['phone'] ?? phone,
          avatarUrl: userData['image'] ?? userData['avatar'],
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data?['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        _errorMessage = e.response?.data?['message'] ?? 
                        e.response?.data?['error'] ?? 
                        'Registration failed. Please try again.';
      } else {
        _errorMessage = 'Registration failed. Please try again.';
      }
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
    if (_user == null) return false;

    _isLoading = true;
    notifyListeners();

    // Update locally first for better UX
    _user = _user!.copyWith(
      fullName: fullName,
      phone: phone,
    );

    try {
      if (_token != null) {
        final response = await ApiService.updateProfile(
          fullName: fullName,
          phone: phone,
          avatar: avatarPath,
        );

        if (response.statusCode == 200) {
          final data = response.data;
          // Update with server response if available
          if (data != null) {
            _user = _user!.copyWith(
              fullName: data['name']?.toString() ?? data['full_name']?.toString() ?? fullName,
              phone: data['phone']?.toString() ?? phone,
              avatarUrl: data['image']?.toString() ?? data['avatar']?.toString() ?? _user!.avatarUrl,
            );
          }

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      
      // If no token or API failed, local update is still applied
      _isLoading = false;
      notifyListeners();
      return true; // Return true since local update succeeded
    } catch (e) {
      // Local update is still applied even if API fails
      _isLoading = false;
      notifyListeners();
      return true; // Return true since local update succeeded
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

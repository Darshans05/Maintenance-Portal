import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final empId = prefs.getString('empId');
    final name = prefs.getString('name');
    if (empId != null && empId.isNotEmpty) {
      _currentUser = User(empId: empId, name: name ?? 'Employee');
      notifyListeners();
    }
  }

  Future<bool> login(String empId, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final user = await _apiService.login(empId, password);
      if (user != null) {
        _currentUser = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('empId', user.empId);
        await prefs.setString('name', user.name);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('empId');
    await prefs.remove('name');
    notifyListeners();
  }
}

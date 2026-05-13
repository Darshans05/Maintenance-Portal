import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../models/user.dart';
import '../models/notification_item.dart';
import '../models/work_order_item.dart';
import '../models/plant_item.dart';

class ApiService {
  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<void> initAuth() async {
    // Auth is now managed by the Node.js backend environment variables
  }

  void clearAuth() {
    // No-op
  }

  Future<User?> login(String empId, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login');
    try {
      final response = await http.post(
        url, 
        headers: _headers,
        body: jsonEncode({'employeeId': empId, 'password': password})
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User(
          empId: data['d']?['EMP_ID'] ?? empId, 
          name: data['d']?['NAME'] ?? 'John Doe'
        );
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<List<NotificationItem>> getNotifications(String empId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notificationSet}');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['d'] != null && data['d']['results'] != null 
                             ? data['d']['results'] 
                             : (data['d'] != null ? [data['d']] : []);
        return results.map((e) => NotificationItem.fromJson(e)).toList();
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<NotificationItem> getNotificationDetail(String qmNum) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/notification/$qmNum');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['d'] ?? data;
        return NotificationItem.fromJson(result);
      } else {
        throw Exception('Failed to load notification detail');
      }
    } catch (e) {
      print('Error fetching notification detail: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<PlantItem>> getPlants() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.plantSet}');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['d'] != null && data['d']['results'] != null 
                             ? data['d']['results'] 
                             : (data['d'] != null ? [data['d']] : []);
        return results.map((e) => PlantItem.fromJson(e)).toList();
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plants: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<List<WorkOrderItem>> getWorkOrders(String empId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.workOrderSet}');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['d'] != null && data['d']['results'] != null 
                             ? data['d']['results'] 
                             : (data['d'] != null ? [data['d']] : []);
        return results.map((e) => WorkOrderItem.fromJson(e)).toList();
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load work orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching work orders: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<WorkOrderItem> getWorkOrderDetail(String aufnr) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/workorder/$aufnr');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['d'] ?? data;
        return WorkOrderItem.fromJson(result);
      } else {
        throw Exception('Failed to load work order detail');
      }
    } catch (e) {
      print('Error fetching work order detail: $e');
      throw Exception('Network error: $e');
    }
  }
}

import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/plant_item.dart';

class PlantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<PlantItem> _plants = [];
  bool _isLoading = false;
  String _error = '';

  List<PlantItem> get plants => _plants;
  PlantItem? get plant => _plants.isNotEmpty ? _plants.first : null;
  int get totalPlants => _plants.length;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPlants() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _plants = await _apiService.getPlants();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPlant() async => fetchPlants();
}

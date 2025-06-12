// provider/classification_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_knn_app/model/medical_data.dart';
import 'package:flutter_knn_app/model/result.dart';
import 'package:flutter_knn_app/service/classification_service.dart';

class ClassificationProvider extends ChangeNotifier {
  final ClassificationService _service = ClassificationService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Result? _result;
  Result? get result => _result;

  String? _error;
  String? get error => _error;

  MedicalData? _currentData;
  MedicalData? get currentData => _currentData;

  void setLoading(bool loading) {
    _isLoading = loading;
    _error = null;
    notifyListeners();
  }

  void setResult(Result newResult) {
    _result = newResult;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> classifyMedicalData(MedicalData data) async {
    try {
      setLoading(true);
      _currentData = data;
      
      // Call the service to get classification result
      final result = await _service.classifyMedicalData(data);
      
      setResult(result);
      setLoading(false);
      
      return true;
    } catch (e) {
      setError('Gagal menganalisis data: ${e.toString()}');
      return false;
    }
  }

  void reset() {
    _result = null;
    _currentData = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Helper method to check if we have valid result
  bool get hasResult => _result != null && _result!.success;

  // Helper method to get prediction risk level
  bool get isHighRisk => _result!.result== 'High Risk';

  // Helper method to get confidence as double
  // double get confidenceLevel {
  //   if (_result['confidence'] != null) {
  //     return double.tryParse(_result['confidence'].toString()) ?? 0.0;
  //   }
  //   return 0.0;
  // }
}
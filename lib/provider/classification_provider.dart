import 'package:flutter/material.dart';

class ClassificationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _result = {};
  Map<String, dynamic> get result => _result;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setResult(Map<String, dynamic> newResult) {
    _result = newResult;
    notifyListeners();
  }

  // Future method for actual API call would go here
  Future<void> classifyPatientData(Map<String, dynamic> patientData) async {
    // This would be replaced with actual API call
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // Dummy logic - replace with actual API response handling
    final symptoms = patientData['symptoms'] as List<String>;
    _result = {
      'prediction': symptoms.length > 3 ? 'High Risk' : 'Low Risk',
      'confidence': (symptoms.length / 8 * 100).toStringAsFixed(1),
      'recommendations': symptoms.length > 3
          ? 'Kami rekomendasikan untuk melakukan pemeriksaan lebih lanjut ke dokter.'
          : 'Lakukan gaya hidup sehat untuk menjaga kesehatan Anda.',
    };
    
    setLoading(false);
  }
}
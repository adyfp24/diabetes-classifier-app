// service/classification_service.dart
import 'dart:convert';
import 'package:flutter_knn_app/model/result.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_knn_app/model/medical_data.dart';

class ClassificationService {
  static const String baseUrl = 'http://localhost:5501'; 
  
  Future<Result> classifyMedicalData(MedicalData data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Result.fromJson(data);
      } else {
        throw Exception('Failed to classify data: ${response.statusCode}');
      }
    } catch (e) {
      // Untuk demo, return dummy data jika API call gagal
      print('API Error: $e');
      // return _getDummyResult(data);
      throw Exception('Failed to classify data: ${e.toString()}');
    }
  }

  // Dummy result untuk testing
  Map<String, dynamic> _getDummyResult(MedicalData data) {
    // Simple logic based on symptoms count and BMI
    final int symptomsCount = data.symptoms!.length;
    final bool isHighRisk = symptomsCount > 3 || data.bmi > 30;
    
    return {
      'prediction': isHighRisk ? 'High Risk' : 'Low Risk',
      'confidence': isHighRisk ? 
        (70 + (symptomsCount * 5)).clamp(70, 95).toString() :
        (30 + (symptomsCount * 10)).clamp(30, 69).toString(),
      'recommendations': isHighRisk
          ? 'Kami sangat merekomendasikan untuk melakukan pemeriksaan lebih lanjut ke dokter spesialis. Gejala yang Anda alami menunjukkan risiko tinggi.'
          : 'Kondisi Anda terlihat baik. Lakukan gaya hidup sehat untuk menjaga kesehatan Anda tetap optimal.',
      'risk_factors': _getRiskFactors(data),
      'next_steps': _getNextSteps(isHighRisk),
    };
  }

  List<String> _getRiskFactors(MedicalData data) {
    List<String> factors = [];
    
    if (data.bmi > 30) factors.add('BMI tinggi (${data.bmi.toStringAsFixed(1)})');
    if (data.age > 45) factors.add('Usia di atas 45 tahun');
    if (data.symptoms!.length > 3) factors.add('Banyak gejala (${data.symptoms!.length} gejala)');
    
    return factors;
  }

  List<String> _getNextSteps(bool isHighRisk) {
    if (isHighRisk) {
      return [
        'Konsultasi dengan dokter dalam 1-2 minggu',
        'Lakukan tes darah lengkap',
        'Pantau gejala yang muncul',
        'Mulai pola hidup sehat',
      ];
    } else {
      return [
        'Lakukan pemeriksaan rutin tahunan',
        'Jaga pola makan sehat',
        'Olahraga teratur minimal 30 menit/hari',
        'Pantau berat badan',
      ];
    }
  }
}
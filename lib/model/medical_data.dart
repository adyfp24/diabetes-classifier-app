import 'package:flutter_knn_app/model/symptom.dart';

class MedicalData {
  final String name;
  final int age;
  final String gender;
  final String bloodType;
  final int bmi;
  final List<Symptom> symptoms;

  MedicalData({
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.bmi,
    required this.symptoms,
  });
}

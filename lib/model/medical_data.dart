import 'package:flutter_knn_app/model/symptom.dart';

class MedicalData {
  final int pregnancies;
  final int glucose;
  final int skinThickness;
  final int insulin;
  final double bmi;
  final int age;
  final List<Symptom>? symptoms;

  MedicalData({
    required this.pregnancies,
    required this.glucose,
    required this.skinThickness,
    required this.insulin,
    required this.bmi,
    required this.age,
    this.symptoms
  });

  Map<String, dynamic> toJson() {
    return {
      'Pregnancies': pregnancies,
      'Glucose': glucose,
      'SkinThickness': skinThickness,
      'Insulin': insulin,
      'BMI': bmi,
      'Age': age,
      'Symptoms': symptoms
    };
  }
}

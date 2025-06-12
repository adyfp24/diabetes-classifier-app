import 'package:flutter/material.dart';

class SymptomScreen extends StatelessWidget{
  const SymptomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom'),
      ),
      body: Center(
        child: Text("Symptom Screen"),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_knn_app/model/medical_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_knn_app/provider/classification_provider.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pregnanciesController = TextEditingController();
  final _glucoseController = TextEditingController();
  final _skinThicknessController = TextEditingController();
  final _insulinController = TextEditingController();
  final _bmiController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _pregnanciesController.dispose();
    _glucoseController.dispose();
    _skinThicknessController.dispose();
    _insulinController.dispose();
    _bmiController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? suffix,
    TextInputType inputType = TextInputType.number,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal.shade600),
        suffixText: suffix,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      keyboardType: inputType,
      style: const TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildInputField(
          controller: _pregnanciesController,
          label: 'Pregnancies',
          icon: Icons.pregnant_woman,
          suffix: 'x',
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _glucoseController,
          label: 'Glucose',
          icon: Icons.bloodtype,
          suffix: 'mg/dL',
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _skinThicknessController,
          label: 'Skin Thickness',
          icon: Icons.format_line_spacing,
          suffix: 'mm',
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _insulinController,
          label: 'Insulin',
          icon: Icons.opacity,
          suffix: 'μU/mL',
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _bmiController,
          label: 'BMI',
          suffix: 'kg/m²',
          icon: Icons.monitor_weight,
          inputType: TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _ageController,
          label: 'Age',
          icon: Icons.cake,
          suffix: 'yrs',
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _handleAnalyze() async {
    if (!_formKey.currentState!.validate()) return;

    final medicalData = MedicalData(
      pregnancies: int.parse(_pregnanciesController.text),
      glucose: int.parse(_glucoseController.text),
      skinThickness: int.parse(_skinThicknessController.text),
      insulin: int.parse(_insulinController.text),
      bmi: double.parse(_bmiController.text),
      age: int.parse(_ageController.text),
      symptoms: [],
    );

    final provider = Provider.of<ClassificationProvider>(
      context,
      listen: false,
    );
    final success = await provider.classifyMedicalData(medicalData);

    if (success) {
      Navigator.pushNamed(context, '/result');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Unknown error occurred'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _handleAnalyze,
          ),
        ),
      );
    }
  }

  Widget _buildSubmitButton() {
    return Consumer<ClassificationProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: provider.isLoading ? null : _handleAnalyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: provider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.analytics),
            label: Text(
              provider.isLoading ? 'Analyzing...' : 'Analyze Now',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Diabetes Analyzer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }
}

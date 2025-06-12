import 'package:flutter/material.dart';
import 'package:flutter_knn_app/model/medical_data.dart';
import 'package:flutter_knn_app/model/symptom.dart';
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

  final List<Symptom> _selectedSymptoms = [];

  final List<Symptom> _symptomsList = [
    Symptom(name: 'Increased thirst'),
    Symptom(name: 'Frequent urination'),
    Symptom(name: 'Extreme hunger'),
    Symptom(name: 'Unexplained weight loss'),
    Symptom(name: 'Fatigue'),
    Symptom(name: 'Blurred vision'),
    Symptom(name: 'Slow-healing sores'),
    Symptom(name: 'Frequent infections'),
    Symptom(name: 'Tingling in hands/feet'),
    Symptom(name: 'Dry mouth'),
    Symptom(name: 'Nausea'),
    Symptom(name: 'Vomiting'),
  ];

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
        prefixIcon: Icon(icon),
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildSymptomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Symptoms',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _symptomsList.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return FilterChip(
              label: Text(symptom.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selected
                      ? _selectedSymptoms.add(symptom)
                      : _selectedSymptoms.remove(symptom);
                });
              },
              selectedColor: Colors.teal,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            );
          }).toList(),
        ),
        if (_selectedSymptoms.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please select at least one symptom',
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildInputField(
          controller: _pregnanciesController,
          label: 'Pregnancies',
          icon: Icons.pregnant_woman,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _glucoseController,
          label: 'Glucose',
          icon: Icons.bloodtype,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _skinThicknessController,
          label: 'Skin Thickness',
          icon: Icons.format_line_spacing,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: _insulinController,
          label: 'Insulin',
          icon: Icons.opacity,
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
        ),
        const SizedBox(height: 24),
        _buildSymptomsSection(),
      ],
    );
  }

  Future<void> _handleAnalyze() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSymptoms.isEmpty) {
      setState(() {});
      return;
    }

    final medicalData = MedicalData(
      pregnancies: int.parse(_pregnanciesController.text),
      glucose: int.parse(_glucoseController.text),
      skinThickness: int.parse(_skinThicknessController.text),
      insulin: int.parse(_insulinController.text),
      bmi: double.parse(_bmiController.text),
      age: int.parse(_ageController.text),
      symptoms: _selectedSymptoms,
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
          height: 50,
          child: ElevatedButton.icon(
            onPressed: provider.isLoading ? null : _handleAnalyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
              provider.isLoading ? 'Analyzing...' : 'Analyze Symptoms',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Analyzer'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildFormSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

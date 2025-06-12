import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_knn_app/provider/classification_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<ClassificationProvider>(context).result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(top: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      result['prediction'] == 'High Risk'
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      size: 80,
                      color: result['prediction'] == 'High Risk'
                          ? Colors.orange
                          : Colors.teal,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      result['prediction'] ?? 'No Result',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: result['prediction'] == 'High Risk'
                                ? Colors.orange
                                : Colors.teal,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${result['confidence']}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(result['recommendations'] ?? ''),
                    const SizedBox(height: 16),
                    if (result['prediction'] == 'High Risk') ...[
                      const Text(
                        'Next Steps:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Jadwalkan konsultasi dengan dokter'),
                      const Text('2. Pantau kadar gula darah secara rutin'),
                      const Text('3. Ikuti resep dokter dan olahraga secara teratur'),
                    ] else ...[
                      const Text(
                        'Preventive Measures:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Jaga kadar gula darah di bawah 100 mg/dL'),
                      const Text('2. Berolahraga secara teratur'),
                      const Text('3. Menjaga keseimbangan makanan'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/symptom'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: const Text('Start New Assessment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
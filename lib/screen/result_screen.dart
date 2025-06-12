import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_knn_app/provider/classification_provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showProcessing = true;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1, curve: Curves.elasticOut),
      ),
    );

    // Start processing animation
    _startProcessingAnimation();
  }

  void _startProcessingAnimation() async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 1));
    
    // Show the processing UI
    setState(() {
      _showProcessing = true;
    });

    // Simulate longer processing time
    await Future.delayed(const Duration(seconds: 2));

    // Hide processing and show result
    setState(() {
      _showProcessing = false;
      _showResult = true;
    });

    // Start the result animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProcessingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * 3.1416,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.cached,
                  size: 60,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Analyzing Your Data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AI kami sedang menganalisis data...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.teal.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultUI(BuildContext context, Map<String, dynamic> result) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
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
                      'Rekomendasi',
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
                        'Langkah Penanganan :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Jadwalkan konsultasi dengan dokter'),
                      const Text('2. Pantau kadar gula darah secara rutin'),
                      const Text('3. Ikuti resep dokter dan olahraga secara teratur'),
                    ] else ...[
                      const Text(
                        'Langkah Pencegahan2:',
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

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<ClassificationProvider>(context).result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Analisis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _showProcessing
              ? _buildProcessingUI()
              : _showResult
                  ? _buildResultUI(context, result)
                  : const SizedBox(),
        ),
      ),
    );
  }
}
// screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_knn_app/provider/classification_provider.dart';

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
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ClassificationProvider>(
        builder: (context, provider, child) {
          if (!provider.hasResult) {
            return const Center(
              child: Text('No analysis result available'),
            );
          }

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildResultHeader(provider),
                        const SizedBox(height: 24),
                        _buildPatientInfo(provider),
                        const SizedBox(height: 24),
                        // _buildRecommendations(provider),
                        // if (provider.result['risk_factors'] != null)
                        //   ...[
                        //     const SizedBox(height: 24),
                        //     _buildRiskFactors(provider),
                        //   ],
                        // if (provider.result['next_steps'] != null)
                        //   ...[
                        //     const SizedBox(height: 24),
                        //     _buildNextSteps(provider),
                        //   ],
                        const SizedBox(height: 32),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResultHeader(ClassificationProvider provider) {
    final result = provider.result;
    final isHighRisk = provider.isHighRisk;
    
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isHighRisk 
                ? [Colors.orange.shade400, Colors.deepOrange.shade600]
                : [Colors.teal.shade400, Colors.teal.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHighRisk 
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result!.result,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Confidence: ${result!.prediction}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(ClassificationProvider provider) {
    final data = provider.currentData;
    if (data == null) return const SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.teal.shade600),
                const SizedBox(width: 8),
                Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Age', '${data.age} years old'),
            _buildInfoRow('BMI', '${data.bmi.toStringAsFixed(1)} kg/m²'),
            _buildInfoRow('Symptoms', '${data.symptoms!.length} selected'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRecommendations(ClassificationProvider provider) {
  //   final recommendations = provider.result['recommendations'] as String?;
  //   if (recommendations == null) return const SizedBox();

  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.lightbulb_outline, color: Colors.amber.shade600),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Recommendations',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.teal.shade700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Colors.amber.shade50,
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Colors.amber.shade200),
  //             ),
  //             child: Text(
  //               recommendations,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 height: 1.5,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildRiskFactors(ClassificationProvider provider) {
  //   final riskFactors = provider.result['risk_factors'] as List<dynamic>?;
  //   if (riskFactors == null || riskFactors.isEmpty) return const SizedBox();

  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.warning_outlined, color: Colors.orange.shade600),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Risk Factors',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.teal.shade700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           ...riskFactors.map((factor) => Container(
  //             margin: const EdgeInsets.only(bottom: 8),
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Colors.orange.shade50,
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Colors.orange.shade200),
  //             ),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   Icons.circle,
  //                   size: 8,
  //                   color: Colors.orange.shade600,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     factor.toString(),
  //                     style: const TextStyle(fontSize: 14),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )).toList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildNextSteps(ClassificationProvider provider) {
  //   final nextSteps = provider.result['next_steps'] as List<dynamic>?;
  //   if (nextSteps == null || nextSteps.isEmpty) return const SizedBox();

  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.checklist, color: Colors.green.shade600),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Next Steps',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.teal.shade700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           ...nextSteps.asMap().entries.map((entry) {
  //             final index = entry.key + 1;
  //             final step = entry.value.toString();
              
  //             return Container(
  //               margin: const EdgeInsets.only(bottom: 8),
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade50,
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(color: Colors.green.shade200),
  //               ),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(4),
  //                     decoration: BoxDecoration(
  //                       color: Colors.green.shade600,
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Text(
  //                       index.toString(),
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: Text(
  //                       step,
  //                       style: const TextStyle(fontSize: 14),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/symptom',
                (route) => false,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text(
              'New Assessment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
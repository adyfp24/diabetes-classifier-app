import 'package:flutter/material.dart';
import 'package:flutter_knn_app/provider/classification_provider.dart';
import 'package:flutter_knn_app/screen/landing_screen.dart';
import 'package:flutter_knn_app/screen/result_screen.dart';
import 'package:flutter_knn_app/screen/symptom_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClassificationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/symptom': (context) => SymptomScreen(),
        '/result': (context) => ResultScreen(),
      },
    );
  }
}

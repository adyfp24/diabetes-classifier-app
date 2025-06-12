import 'package:flutter/material.dart';

class ClassificationProvider extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _error = false;
  bool get error => _error;
}
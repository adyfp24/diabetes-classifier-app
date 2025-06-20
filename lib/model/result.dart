class Result {
  final int prediction;
  final String result;
  final bool success;
  final double confidence;

  Result({
    required this.prediction,
    required this.result,
    required this.success,
    this.confidence = 0.0,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      prediction: json['prediction'],
      result: json['result'],
      success: json['success'],
      confidence: json['confidence'],
    );
  }
}

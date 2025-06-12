class Result {
  final int prediction;
  final String result;
  final bool success;

  Result({
    required this.prediction,
    required this.result,
    required this.success,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      prediction: json['prediction'],
      result: json['result'],
      success: json['success'],
    );
  }
}

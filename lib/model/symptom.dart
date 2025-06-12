
class Symptom {
  final String name;
  final bool isSelected;

  Symptom({
    required this.name,
    this.isSelected = false,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      name: json['name'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isSelected': isSelected,
    };
  }

  Symptom copyWith({
    String? name,
    bool? isSelected,
  }) {
    return Symptom(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
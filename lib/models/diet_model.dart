class FoodLogModel {
  final String logId;
  final String userId;
  final DateTime logDate;
  final String mealType;
  final String foodName;
  final double portion;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodLogModel({
    required this.logId,
    required this.userId,
    required this.logDate,
    required this.mealType,
    required this.foodName,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodLogModel.fromMap(Map<String, dynamic> map, String id) {
    return FoodLogModel(
      logId: id,
      userId: map['userId'] ?? '',
      logDate: map['logDate']?.toDate() ?? DateTime.now(),
      mealType: map['mealType'] ?? '',
      foodName: map['foodName'] ?? '',
      portion: (map['portion'] ?? 0).toDouble(),
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'logDate': logDate,
      'mealType': mealType,
      'foodName': foodName,
      'portion': portion,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
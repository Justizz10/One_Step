class UserModel {
  final String uid;
  String name;
  String username;
  String email;
  String gender;
  int age;
  double height;
  double weight;
  String goal;
  String activityLevel;
  String photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
    required this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      age: (map['age'] ?? 0) is int
          ? map['age']
          : int.tryParse('${map['age']}') ?? 0,
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      goal: map['goal'] ?? '',
      activityLevel: map['activityLevel'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'goal': goal,
      'activityLevel': activityLevel,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }
}
class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;
  final String registrationDate;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.registrationDate,
  });

  // from user model to firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'registrationDate': registrationDate,
    };
  }

  // from firestore to user model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? 'user',
      registrationDate: map['registrationDate'] ?? '',
    );
  }
}

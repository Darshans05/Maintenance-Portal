class User {
  final String empId;
  final String name;

  User({required this.empId, this.name = 'Employee'});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      empId: json['EMP_ID'] ?? '',
      name: json['NAME'] ?? 'Employee',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EMP_ID': empId,
      'NAME': name,
    };
  }
}

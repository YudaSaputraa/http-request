class User {
  final int? id;
  final String? name;
  final String? email;
  final String? gender;

  User({
    this.id,
    this.name,
    this.email,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // sama seperti constructor biasa tapi bisa ditambah logika
    return User(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'gender': gender ?? '',
    };
  }
} 
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
    String? gender = json['gender'] as String?;
    if (gender != null && gender.isNotEmpty) {
      gender = gender.toLowerCase();
    } else {
      gender = 'male'; //diisi default value
    }

    return User(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'gender': gender ?? 'male',
    };
  }
} 
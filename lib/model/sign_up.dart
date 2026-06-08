class SignUpModel {
  final String username;
  final String email;
  final String password;
  String? name;
  String? timezone;

  SignUpModel({
    required this.username,
    required this.email,
    required this.password,
    this.name,
    this.timezone,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      if (name != null) 'name': name,
      if (timezone != null) 'timezone': timezone,
    };
  }
}

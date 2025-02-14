import 'dart:convert';

/// Model untuk login input
class LoginInput {
  final String username;
  final String password;
  final String role;

  LoginInput({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "role": role,
      };
}

/// Model untuk response login
class LoginResponse {
  final String message;
  final String status;

  LoginResponse({
    required this.message,
    required this.status,
  });

  /// Factory constructor untuk mengubah JSON menjadi objek LoginResponse
  factory LoginResponse.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json); // Jika JSON berbentuk String, ubah jadi Map
    }
    return LoginResponse(
      message: json["message"] ?? "",
      status: json["status"] ?? "",
    );
  }
}

/// Model untuk register input
class RegisterInput {
  final String username;
  final String password;
  final String role;

  RegisterInput({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "role": role,
      };
}

/// Model untuk response register
class RegisterResponse {
  final String message;

  RegisterResponse({
    required this.message,
  });

  /// Factory constructor untuk mengubah JSON menjadi objek RegisterResponse
  factory RegisterResponse.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return RegisterResponse(
      message: json["message"] ?? "",
    );
  }
}

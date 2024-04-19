class LoginResponse {
  final String jwtToken;

  const LoginResponse({required this.jwtToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'jwtToken': String jwtToken,
      } =>
        LoginResponse(
          jwtToken: jwtToken,
        ),
      _ => throw const FormatException('Failed to load login response'),
    };
  }
}

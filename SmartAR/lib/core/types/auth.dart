class APIStatus {
  final int code;
  final String message;
  final bool success;

  APIStatus({required this.code, required this.message, required this.success});
}

class StatusCode {
  static const int success = 200;
  static const int network = 0;
  static const int timeout = 408;
  static const int unAuthenticated = 401;
  static const int unAuthentorized = 403;
}

class AuthRes {
  final JwtToken token;
  final MiniUser user;

  AuthRes({required this.user, required this.token});

  factory AuthRes.fromJson(Map<String, dynamic> json) {
    return AuthRes(
      user: MiniUser.fromJson(json["user"]),
      token: JwtToken.fromJson(json['token']),
    );
  }
}

class MiniUser {
  final String email;
  final String name;
  final List<int> roles;
  final bool verified;
  MiniUser({
    required this.email,
    required this.name,
    required this.roles,
    required this.verified,
  });

  factory MiniUser.fromJson(Map<String, dynamic> json) {
    return MiniUser(
      email: json['email'],
      name: json['name'],
      roles: List<int>.from(json['roles']),
      verified: json['verified'],
    );
  }
}

class JwtToken {
  final String accessToken;
  final String refreshToken;

  JwtToken({required this.accessToken, required this.refreshToken});

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }
}

class APIErrorDTO {
  final int statusCode;
  final dynamic message;

  APIErrorDTO({required this.statusCode, this.message});
}

class APIRes<T> {
  final APIStatus status;
  final T? data;

  APIRes({required this.status, this.data});
}

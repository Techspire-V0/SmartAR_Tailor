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
  final String message;

  AuthRes({required this.message, required this.user, required this.token});
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
}

class JwtToken {
  final String accessToken;
  final String refreshToken;

  JwtToken({required this.accessToken, required this.refreshToken});
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

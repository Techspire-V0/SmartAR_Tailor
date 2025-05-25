import 'package:SmartAR/core/types/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final MiniUser? user;

  AuthState({this.user});

  bool get isAuth => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void login(MiniUser user) {
    state = AuthState(user: user);
  }

  void logout() {
    state = AuthState(user: null);
  }
}

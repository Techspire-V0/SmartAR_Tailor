import 'package:smartar/core/services/auth_services.dart';
import 'package:smartar/core/types/auth.dart';
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

  Future<void> tryAuth(WidgetRef ref) async {
    await authServices.tryAuth(ref);
  }

  void logout() {
    if (state.user != null) {
      state = AuthState(user: null);
    }
  }
}

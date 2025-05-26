import 'dart:convert';

import 'package:smartar/core/services/token_storage.dart';
import 'package:smartar/core/types/auth.dart';
import 'package:smartar/data/sources/providers/index.dart';
import 'package:smartar/data/sources/remote/instances.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AuthService {
  final _googleSignIn = GoogleSignIn(
    clientId:
        '732232446183-7arcbs5ruug0tfrbgrap0gma4398n1p2.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<void> googleAuth(WidgetRef ref) async {
    final account = await _googleSignIn.signIn();
    if (account != null) {
      final auth = await account.authentication;
      final idToken = auth.idToken;

      // try {
      final Response<APIRes<dynamic>> response = await authHttp.post(
        '/google',
        data: {"idToken": idToken},
      );

      if (response.data!.status.success) {
        final res = AuthRes.fromJson(response.data!.data);
        await tokenStorage.saveTokens(res.token);
        ref.read(authProvider.notifier).login(res.user);
      }

      if (response.data!.status.code == StatusCode.unAuthenticated) logout(ref);

      ref.read(statusMessageProv.notifier).state = response.data!.status;
      return;
    }

    ref.read(statusMessageProv.notifier).state = APIStatus(
      code: 500,
      message: "Unable to access google account",
      success: false,
    );
    return;
  }

  Future<void> auth(
    WidgetRef ref,
    Map<String, dynamic> data, {
    bool? isSignin = true,
  }) async {
    final path = isSignin! ? '/sign_in' : '/sign_up';

    // try {
    final Response<APIRes<dynamic>> response = await authHttp.post(
      path,
      data: jsonEncode(data),
    );

    if (response.data!.status.success) {
      final res = AuthRes.fromJson(response.data!.data);
      await tokenStorage.saveTokens(res.token);
      ref.read(authProvider.notifier).login(res.user);
    }

    if (response.data!.status.code == StatusCode.unAuthenticated) logout(ref);

    ref.read(statusMessageProv.notifier).state = response.data!.status;
  }

  Future<void> tryAuth(WidgetRef ref) async {
    // try {
    final Response<APIRes<dynamic>> response = await authHttp.get(
      '/try_sign_in',
    );

    if (response.data!.status.success) {
      final user = MiniUser.fromJson(response.data!.data);
      ref.read(authProvider.notifier).login(user);
    }

    if (response.data!.status.code == StatusCode.unAuthenticated) logout(ref);
  }

  Future<void> logout(WidgetRef ref) async {
    await _googleSignIn.signOut();
    await tokenStorage.logout();
    ref.read(authProvider.notifier).logout();
  }
}

final authServices = _AuthService();

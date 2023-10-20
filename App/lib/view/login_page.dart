import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/utils/auth_service.dart';
import 'package:gohan_map/utils/auth_state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider); //ログインしているユーザーの情報を確認するProvider
    final isSignedIn =
        ref.watch(isSignedInProvider); //ログインしているかどうかを確認するProvider
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) Text(user.displayName ?? "不明"),
            Text((isSignedIn) ? "ログイン中" : "未ログイン"),
            ElevatedButton(
              onPressed: () async {
                final service = AuthService();
                service.signInWithGoogle();
              },
              child: const Center(child: Text("ログイン")),
            ),
            ElevatedButton(
              onPressed: () async {
                final service = AuthService();
                service.signOut();
              },
              child: const Center(child: Text("ログアウト")),
            ),
          ],
        ),
      ),
    );
  }
}

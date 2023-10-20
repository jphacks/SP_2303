import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/main.dart';
import 'package:gohan_map/utils/auth_service.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedIn =
        ref.watch(isSignedInProvider); //ログインしているかどうかを確認するProvider
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.google, onPressed: () {
              final service = AuthService();
              service.signInWithGoogle().then((value) => {
                    if (value != null)
                      {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage(),
                          ),
                        )
                      }
                  });
            })
          ],
        ),
      ),
    );
  }
}

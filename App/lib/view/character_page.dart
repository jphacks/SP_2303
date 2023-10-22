import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/utils/auth_service.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/view/login_page.dart';

class CharacterPage extends ConsumerStatefulWidget {
  const CharacterPage({super.key});

  @override
  ConsumerState<CharacterPage> createState() => CharacterPageState();
}

class CharacterPageState extends ConsumerState<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "育成ページ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(ref.watch(userProvider).toString() ?? ""),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                final service = AuthService();
                service.signOut().then((result) => onLogout(result, context));
              },
              child: const Center(child: Text("ログアウト")),
            ),
          ),
        ],
      ),
    );
  }

  Set<Future<dynamic>> onLogout(int result, BuildContext context) {
    return {
      if (result == 0)
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false),
      if (result == 1)
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("ログアウトに失敗しました"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              );
            })
    };
  }

  //タブを選択した時に行う再描画処理
  void reload() {}
}

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
                service.signOut().then((value) => {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false)
                    });
              },
              child: const Center(child: Text("ログアウト")),
            ),
          ),
        ],
      ),
    );
  }

  //タブを選択した時に行う再描画処理
  void reload() {}
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/utils/auth_service.dart';
import 'package:gohan_map/view/login_page.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ListTile> listTiles = [
      ListTile(
        title: const Text("ログアウト"),
        onTap: () async {
          final service = AuthService();
          service.signOut().then((result) => onLogout(result, context));
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定", style: TextStyle(fontWeight: FontWeight.bold)),
        //白
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return listTiles[index];
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: listTiles.length),
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/auth_service.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/view/login_page.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider);
    //名前
    final String name = user?.displayName ?? "匿名";
    //プロバイダ名
    String provider = user?.providerData[0].providerId ?? "不明";
    if (provider == "google.com") {
      provider = "Google";
    } else if (provider == "apple.com") {
      provider = "Apple";
    }

    List<Widget> listTiles = [
      CupertinoFormSection.insetGrouped(
        header: const Text("設定"),
        children: [
          InkWell(
            onTap: () async {
              final service = AuthService();
              service.signOut().then((result) => onLogout(result, context));
            },
            child: CupertinoFormRow(
              prefix: const Text(
                "ログアウト",
              ),
              helper: Text("$name さんが $provider でログイン中",
                  style: const TextStyle(fontSize: 14)),
              child: Container(),
            ),
          ),
          InkWell(
            onTap: () async {
              onPressedDeleteAccount(context, ref);
            },
            child: CupertinoFormRow(
              prefix: const Text("退会する"),
              helper: const Text("アカウントを完全に削除し、アップロード済みの画像を削除します。",
                  style: TextStyle(fontSize: 14)),
              child: Container(),
            ),
          ),
        ],
      ),
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("設定", style: TextStyle(fontWeight: FontWeight.bold)),

      ),
      child: Container(
        color: CupertinoColors.systemGroupedBackground,
        height: double.infinity,
        child: ListView(
          children: listTiles,
        ),
      ),
    );
  }

  //退会ボタンが押されたら
  Future<void> onPressedDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    //アクションシートを出す
    final action = await showCupertinoModalPopup<int>(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text("本当に退会しますか？"),
            message: const Text("退会すると、投稿した画像も削除されます。"),
            actions: [
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: const Text("退会する"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context, 1);
              },
            ),
          );
        });
    //キャンセルが押されたら
    if (action != 0) {
      return;
    }
    //アカウント削除APIを叩く
    final apires = await APIService.requestDeleteUserAPI(
        await ref.watch(userProvider)?.getIdToken());
    if (apires.isNotEmpty && context.mounted) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                "投稿の削除に失敗しました",
              ),
              content: Text(apires),
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  },
                ),
              ],
            );
          });
      return;
    }
    final service = AuthService();
    service.deleteAccount().then((result) => onDeleteAccount(result, context));
  }

  Set<Future<dynamic>> onDeleteAccount(int result, BuildContext context) {
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
                title: const Text("ユーザ情報の\n削除に失敗しました"),
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

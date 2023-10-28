import 'package:flutter/Cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//経験値を増加させ、ダイアログを表示する
Future getAndShowExpDialog({
  required BuildContext context,
  required String title, //ダイアログのタイトル
  required int exp, //獲得させる経験値
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //経験値を増加
  prefs.setInt("exp", prefs.getInt("exp") ?? 0 + exp);
  if (context.mounted) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            children: [
              SizedBox(
                height: 100,
                child: Image.network(
                  "https://www.webtech.co.jp/help/wp-content/uploads/2015/10/comipo24bit.png",
                ),
              ),
              Text("経験値を$exp獲得しました"),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

//経験値を取得する
Future<int> getExp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("exp") ?? 0;
}

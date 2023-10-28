import 'package:flutter/material.dart';
import 'package:gohan_map/colors/app_colors.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => CharacterPageState();
}

class CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Text("ステータス"),
        Image.asset(
          "images/normal.png",
          height: 300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 186,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.primaryColor,
              ),
              child: const Text(
                "行ったお店の数",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            const Column(
              children: [
                Text(
                  "150",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                ),
                Text(
                  "(今月 +20)",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 186,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.primaryColor,
              ),
              child: const Text(
                "記録した数",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            const Column(
              children: [
                Text(
                  "300",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                ),
                Text(
                  "(今月 +50)",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
        const Row(
          children: [
            Icon(
              Icons.restaurant,
              size: 24,
              color: AppColors.primaryColor,
            ),
            Text(
              "食べたもの記録",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    );
  }

  //タブを選択した時に行う再描画処理
  void reload() {}
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_character.dart';
import 'package:gohan_map/component/app_exp_dialog.dart';
import 'package:gohan_map/utils/common.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/post_detail_page.dart';
import 'package:path/path.dart' as p;

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => CharacterPageState();
}

class CharacterPageState extends State<CharacterPage> {
  List<Timeline> shopTimeline = [];
  List<Shop> shops = [];
  int exp = 0;

  @override
  void initState() {
    super.initState();
    () async {
      final allShops = await IsarUtils.getAllShops();
      final timelines = await IsarUtils.getAllTimelines();
      final exp = await getExp();
      setState(() {
        shopTimeline = timelines;
        shops = allShops;
        this.exp = exp;
      });
    }();
  }

  void reload() {
    () async {
      final allShops = await IsarUtils.getAllShops();
      final timelines = await IsarUtils.getAllTimelines();
      final exp = await getExp();
      setState(() {
        shopTimeline = timelines;
        shops = allShops;
        this.exp = exp;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime thisMonthDay = DateTime(now.year, now.month, 1);

    // レベル情報
    var levelObj = Level(exp);
    int level = levelObj.level;
    int expOfCurLevel = levelObj.expOfCurLevel;
    int needExpForNextLevel = levelObj.needExpNextLevel;

    int allNewShopSize = shops.where((el) => el.wantToGoFlg == false).length;
    int allTimelineSize = shopTimeline.length;
    // TODO: 店単位の初投稿の日付が今月のものの個数を取得するように変更する
    int thisMonthNewShopSize = shops
        .where((el) =>
            el.wantToGoFlg == false &&
            el.createdAt.compareTo(thisMonthDay) == 1)
        .length;
    int thisMonthTimelineSize =
        shopTimeline.where((el) => el.date.compareTo(thisMonthDay) == 1).length;

    // 食べたもの記録に表示するタイムラインを作成
    List<Timeline> shopTimelineWithImg = [];
    for (Timeline timeline in shopTimeline) {
      if (timeline.images.isNotEmpty) {
        shopTimelineWithImg.add(timeline);
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "レベル",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$level",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 30,
                          ),
                        )
                      ],
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("うまぽよ",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 25,
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$expOfCurLevel",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "/",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "$needExpForNextLevel",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 2),
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: LinearProgressIndicator(
                      value: expOfCurLevel / needExpForNextLevel,
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.greyColor,
                      minHeight: 14,
                    ))
              ],
            ),
            // キャラクター
            const AppCharacter(),
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "新規店舗の数",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        allNewShopSize.toString(),
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "(今月 +$thisMonthNewShopSize)",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Column(
                    children: [
                      Text(
                        allTimelineSize.toString(),
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "(今月 +$thisMonthTimelineSize)",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 28,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "食べたもの記録",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              //Gridで画像を表示
              FutureBuilder(
                  future: getLocalPath(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    } else {
                      //画像がある投稿のみを表示
                      if (shopTimelineWithImg.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text("投稿がありません"),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shopTimelineWithImg.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              final s = shopTimelineWithImg[index].shopId;
                              final shop = await IsarUtils.getShopById(s);
                              if (mounted && shop != null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PostDetailPage(
                                      timeline: shopTimelineWithImg[index],
                                      imageData: snapshot.data,
                                      shop: shop,
                                    ),
                                  ),
                                ).then((value) => {
                                      if (value == "delete")
                                        {
                                          setState(() {
                                            shopTimeline.remove(
                                                shopTimelineWithImg[index]);
                                          })
                                        }
                                    });
                              }
                            },
                            child: Stack(fit: StackFit.expand, children: [
                              Image.file(
                                File(p.join(snapshot.data!,
                                    shopTimelineWithImg[index].images[0])),
                                fit: BoxFit.cover,
                              ),
                              if (shopTimelineWithImg[index].images.length >= 2)
                                const Positioned(
                                    top: 8,
                                    right: 4,
                                    child: Icon(
                                      Icons.file_copy,
                                      size: 23,
                                      color: AppColors.whiteColor,
                                    ))
                            ]),
                          );
                        },
                      );
                    }
                  }),
            ])
          ],
        ),
      ),
    );
  }
}

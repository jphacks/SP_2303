import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/colors/app_colors.dart';
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
  List<Timeline>? shopTimeline;

  @override
  void initState() {
    super.initState();
    () async {
      final timelines = await IsarUtils.getAllTimelines();
      setState(() {
        shopTimeline = timelines;
      });
    }();
  }

  void reload() {
    () async {
      final timelines = await IsarUtils.getAllTimelines();
      setState(() {
        shopTimeline = timelines;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    List<Timeline> shopTimelineWithImg = [];
    if (shopTimeline != null) {
      for (Timeline timeline in shopTimeline!) {
        if (timeline.images.isNotEmpty) {
          shopTimelineWithImg.add(timeline);
        }
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "レベル",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "21",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 30,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "2320",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "/",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          "2500",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 2),
                LinearProgressIndicator(
                  value: 2320 / 2500,
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.greyColor,
                  minHeight: 14,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                )
              ],
            ),
            Image.asset(
              "images/normal_close.png",
              height: 300,
            ),
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
                      "行ったお店の数",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const Column(
                    children: [
                      Text(
                        "150",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 36,
                        ),
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
                  const Column(
                    children: [
                      Text(
                        "300",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "(今月 +50)",
                        style: TextStyle(fontSize: 16),
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
                                      timeline: shopTimeline![index],
                                      imageData: snapshot.data,
                                      shop: shop,
                                    ),
                                  ),
                                ).then((value) => {
                                      if (value == "delete")
                                        {
                                          setState(() {
                                            shopTimeline!.remove(
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

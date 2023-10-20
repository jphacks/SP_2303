import 'dart:io';

import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/component/post_card_widget.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/place_post_page.dart';
import 'package:gohan_map/view/post_detail_page.dart';

import '../utils/common.dart';

class AllPostPage extends StatefulWidget {
  const AllPostPage({super.key});

  @override
  State<AllPostPage> createState() => AllPostPageState();
}

class AllPostPageState extends State<AllPostPage> {
  List<Timeline>? shopTimeline;
  int segmentIndex = 1;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'すべての投稿',
          style: TextStyle(color: Colors.black),
        ),
        //色
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoSlidingSegmentedControl(
                    groupValue: segmentIndex,
                    children: const <int, Widget>{
                      0: Text("投稿"),
                      1: Text("メディア"),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        segmentIndex = value as int;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            if (segmentIndex == 0)
              FutureBuilder(
                  future: getLocalPath(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    } else {
                      if ((shopTimeline ?? []).isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text("投稿がありません"),
                        );
                      }
                      return Column(
                        children: [
                          for (Timeline timeline in (shopTimeline ?? []))
                            FutureBuilder(
                                future: IsarUtils.getShopById(timeline.shopId),
                                builder: (context, snapshot2) {
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 12, 16, 0),
                                        width: double.infinity,
                                        child: Text(
                                          snapshot2.data?.shopName ?? "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      if (snapshot2.data != null)
                                        PostCardWidget(
                                          timeline: timeline,
                                          imageData: snapshot.data!,
                                          onEditTapped: () {
                                            showModalBottomSheet(
                                              //モーダルを表示する関数
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              isScrollControlled:
                                                  true, //スクロールで閉じたりするか
                                              builder: (context) {
                                                if (snapshot2.data != null) {
                                                  return PlacePostPage(
                                                    shop: snapshot2.data!,
                                                    timeline: timeline,
                                                  ); //ご飯投稿
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ).then((value) {
                                              if (value == null) {
                                                return;
                                              }
                                              IsarUtils.getAllTimelines()
                                                  .then((timeline) {
                                                setState(() {
                                                  shopTimeline = timeline;
                                                });
                                              });
                                            });
                                          },
                                          onDeleteTapped: () {
                                            IsarUtils.deleteTimeline(
                                                timeline.id);
                                            setState(() {
                                              shopTimeline!.remove(timeline);
                                            });
                                          },
                                        ),
                                      const Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                    ],
                                  );
                                }),
                        ],
                      );
                    }
                  }),
            if (segmentIndex == 1)
              //Gridで画像を表示
              FutureBuilder(
                  future: getLocalPath(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    } else {
                      //画像がある投稿のみを表示
                      if (shopTimelineWithImg == null ||
                          shopTimelineWithImg.isEmpty) {
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
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              final s = shopTimelineWithImg![index].shopId;
                              final shop = await IsarUtils.getShopById(s);
                              if (mounted && shop != null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PostDetailPage(
                                      timeline: shopTimelineWithImg![index],
                                      imageData: snapshot.data,
                                      shop: shop,
                                    ),
                                  ),
                                ).then((value) => {
                                      if (value == "delete")
                                        {
                                          setState(() {
                                            shopTimeline!.remove(
                                                shopTimelineWithImg![index]);
                                          })
                                        }
                                    });
                              }
                            },
                            child: Image.file(
                              File(p.join(snapshot.data!,
                                  shopTimelineWithImg[index].images[0])),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }
                  }),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';
import 'package:gohan_map/component/post_card_widget.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/utils/common.dart';
import 'package:gohan_map/view/place_post_page.dart';
import 'package:gohan_map/view/place_update_page.dart';

import 'package:isar/isar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/isar_utils.dart';

///飲食店の詳細画面
class PlaceDetailPage extends StatefulWidget {
  final Id id;
  const PlaceDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  Shop? selectedShop;
  List<Timeline>? shopTimeline;
  double aveStar = 0.0;
  @override
  void initState() {
    super.initState();
    () async {
      final shop = await IsarUtils.getShopById(widget.id);
      if (shop == null) return;

      final timelines = await IsarUtils.getTimelinesByShopId(shop.id);

      setState(() {
        selectedShop = shop;
        shopTimeline = timelines;
        //平均
        aveStar = calcAveStar(timelines);
      });
    }();
  }

  double calcAveStar(List<Timeline> timelines) {
    List<double> stars = [];
    for (Timeline p in timelines) {
      stars.add(p.star);
    }
    if (stars.isEmpty) {
      return 0.0;
    }
    return stars.reduce((a, b) => a + b) / stars.length;
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
        backgroundColor: Colors.white,
        initialChildSize: 0.55,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedShop?.wantToGoFlg ?? false)
                  Container(
                      alignment: Alignment.centerRight,
                      child: const _WantToGoBudge()),
                ShopNameHeader(
                  title: selectedShop?.shopName ?? "",
                  address: selectedShop?.shopAddress ?? "",
                ),
                const Divider(
                  color: AppColors.greyColor,
                  thickness: 1,
                  height: 16,
                ),
                if (selectedShop != null)
                  Wrap(
                    spacing: 12,
                    children: [
                      SubButton(
                        title: '編集',
                        icon: Icons.edit,
                        onPressed: () {
                          showModalBottomSheet(
                            //モーダルを表示する関数
                            barrierColor:
                                Colors.black.withOpacity(0), //背景をどれぐらい暗くするか
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true, //スクロールで閉じたりするか
                            builder: (context) {
                              return PlaceUpdatePage(
                                shop: selectedShop!,
                              ); //ご飯投稿
                            },
                          ).then((value) {
                            IsarUtils.getShopById(widget.id).then((shop) {
                              setState(() {
                                selectedShop = shop;
                              });
                            });
                          });
                        },
                      ),
                      SubButton(
                        title: "共有",
                        icon: AppIcons.share,
                        onPressed: () {
                          Share.shareUri(
                            Uri.parse(
                                "https://www.google.com/maps/place/?q=${selectedShop!.shopName}"),
                          );
                        },
                      ),
                      SubButton(
                        title: "GoogleMapで開く",
                        icon: Icons.map,
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                              "https://www.google.com/maps/place/?q=${selectedShop!.shopName}",
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
                //記録一覧
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColors.tabBarColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "記録一覧",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                //記録ボタン
                Center(
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (selectedShop == null) {
                          return;
                        }
                        showModalBottomSheet(
                          //モーダルを表示する関数
                          barrierColor:
                              Colors.black.withOpacity(0), //背景をどれぐらい暗くするか
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true, //スクロールで閉じたりするか
                          builder: (context) {
                            return PlacePostPage(
                              shop: selectedShop!,
                            ); //ご飯投稿
                          },
                        ).then((value) {
                          Future(() async {
                            final timeline =
                                await IsarUtils.getTimelinesByShopId(
                                    selectedShop!.id);
                            final shop =
                                await IsarUtils.getShopById(selectedShop!.id);
                            setState(() {
                              shopTimeline = timeline;
                              selectedShop = shop;
                              aveStar = calcAveStar(timeline);
                            });
                          });
                        });
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: AppColors.whiteColor,
                            size: 25,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "記録する",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: getLocalPath(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  );
                } else {
                  return Column(children: [
                    if (shopTimeline?.isEmpty ?? true)
                      Column(
                        children: [
                          //画像
                          Padding(
                            padding: const EdgeInsets.only(left: 100),
                            child: Image.asset(
                              "images/arrow_spin.png",
                              height: 80,
                            ),
                          ),
                          const Text(
                            "記録がまだありません\n1つ目の記録を追加しましょう",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    if (shopTimeline?.isNotEmpty ?? false)
                      const SizedBox(
                        height: 16,
                      ),
                    for (Timeline timeline in (shopTimeline ?? [])) ...[
                      PostCardWidget(
                        timeline: timeline,
                        imageData: snapshot.data!,
                        onEditTapped: () {
                          if (selectedShop == null) {
                            return;
                          }
                          showModalBottomSheet(
                            //モーダルを表示する関数
                            barrierColor:
                                Colors.black.withOpacity(0), //背景をどれぐらい暗くするか
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true, //スクロールで閉じたりするか
                            builder: (context) {
                              return PlacePostPage(
                                shop: selectedShop!,
                                timeline: timeline,
                              ); //ご飯投稿
                            },
                          ).then((value) {
                            IsarUtils.getTimelinesByShopId(selectedShop!.id)
                                .then((timeline) {
                              setState(() {
                                shopTimeline = timeline;
                                aveStar = calcAveStar(timeline);
                              });
                            });
                          });
                        },
                        onDeleteTapped: () {
                          IsarUtils.deleteTimeline(timeline.id);
                          setState(() {
                            shopTimeline!.remove(timeline);
                            aveStar = calcAveStar(shopTimeline!);
                          });
                        },
                      ),
                    ],
                  ]);
                }
              }),
        ]));
  }
}

class ShopNameHeader extends StatelessWidget {
  const ShopNameHeader({
    super.key,
    required this.title,
    required this.address,
  });
  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.place,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 2, top: 20),
                    ),
                    Flexible(
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final IconData icon;
  const SubButton({
    required this.title,
    required this.icon,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const foreColor = Color(0xff515151);
    const backColor = AppColors.whiteColor;
    const showBorder = true;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backColor,
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: (showBorder)
              // ignore: dead_code
              ? const BorderSide(color: foreColor, width: 1)
              // ignore: dead_code
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: RichText(
          text: TextSpan(children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(icon, size: 18, color: foreColor),
              ),
            ),
            TextSpan(
                text: title,
                style: TextStyle(
                  color: foreColor,
                  fontFamily: (Platform.isAndroid) ? "SanFrancisco" : null,
                  fontFamilyFallback:
                      (Platform.isAndroid) ? ["HiraginoSans"] : null,
                )),
          ]),
        ),
      ),
    );
  }
}


class _WantToGoBudge extends StatelessWidget {
  const _WantToGoBudge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.whiteColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        color: const Color(0xFFFF5959),
      ),
      child: const Text(
        "行ってみたい！",
        style: TextStyle(
            height: 1.2,
            fontFamily: "SFProRounded",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 10),
      ),
    );
  }
}

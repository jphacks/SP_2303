import 'dart:io';

import 'package:flutter/Cupertino.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_haptic/haptic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/component/app_exp_dialog.dart';
import 'package:gohan_map/component/post_food_widget.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/utils/common.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/place_detail_page.dart';
import 'package:path/path.dart' as p;

import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';

// 飲食店でのごはん投稿・編集画面
class PlacePostPage extends ConsumerStatefulWidget {
  final Shop shop;
  final Timeline? timeline; // 編集ページの際に外部から初期データを渡す

  const PlacePostPage({Key? key, required this.shop, this.timeline})
      : super(key: key);

  @override
  ConsumerState<PlacePostPage> createState() => _PlacePostPageState();
}

class _PlacePostPageState extends ConsumerState<PlacePostPage> {
  List<File> images = [];
  DateTime date = DateTime.now();
  String comment = '';
  double star = 4.0;
  bool isPublic = true;
  bool avoidkeyBoard = false;
  bool isAPIRequesting = false;

  @override
  void initState() {
    super.initState();

    Future(() async {
      if (widget.timeline != null) {
        // 編集画面
        images = widget.timeline!.images.isNotEmpty
            ? await Future.wait(
                widget.timeline!.images.map((e) async {
                  return File(p.join(await getLocalPath(), e));
                }),
              )
            : [];
        date = widget.timeline!.date;
        comment = widget.timeline!.comment;
        star = widget.timeline!.star;
        isPublic = widget.timeline!.isPublic;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      initialChildSize: 0.9,
      avoidKeyboardFlg: avoidkeyBoard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShopNameHeader(
                      title: widget.shop.shopName,
                      address: widget.shop.shopAddress,
                    ),
                    const Divider(
                      color: AppColors.greyColor,
                      thickness: 1,
                      height: 16,
                    ),
                    Text(
                      (widget.timeline != null) ? "記録の編集" : "新規記録",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            // 追加の投稿
            PostFoodWidget(
              images: images,
              onImageAdded: (image) {
                setState(() {
                  images.add(image);
                });
              },
              onImageDeleted: (index) {
                setState(() {
                  images.removeAt(index);
                });
              },
              initialStar: star,
              onStarChanged: (star) {
                setState(() {
                  this.star = star;
                });
              },
              initialDate: date,
              onDateChanged: (date) {
                setState(() {
                  this.date = date;
                });
              },
              initialComment: comment,
              onCommentChanged: (comment) {
                setState(() {
                  this.comment = comment;
                });
              },
              onCommentFocusChanged: (isFocus) {
                setState(() {
                  avoidkeyBoard = isFocus;
                });
              },
              enablePublic: images.isNotEmpty,
              initialPublic: isPublic,
              onPublicChanged: (isPublic) {
                setState(() {
                  this.isPublic = isPublic;
                });
              },
            ),
            //決定ボタン
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 30, bottom: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: AppColors.whiteColor,
                  backgroundColor: (isAPIRequesting)
                      ? AppColors.greyColor
                      : AppColors.primaryColor,
                ),
                onPressed: (isAPIRequesting)
                    ? null
                    : () async {
                        setState(() {
                          isAPIRequesting = true;
                        });
                        await onTapComfirm(context);
                        setState(() {
                          isAPIRequesting = false;
                        });
                      },
                child: const Text(
                  '決定',
                  style: TextStyle(
                      color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // キャンセルボタン
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(bottom: 50),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: AppColors.blackTextColor,
                  backgroundColor: AppColors.whiteColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'キャンセル',
                  style: TextStyle(
                      color: AppColors.redTextColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //決定ボタンを押した時の処理
  Future<void> onTapComfirm(BuildContext context) async {
    if (images.isEmpty && comment.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('投稿の入力がありません'),
            actions: [
              CupertinoDialogAction(
                child: const Text('閉じる'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return;
    }
    if (!(isPublic && images.isNotEmpty) && widget.timeline != null) {
      //画像がないか非公開でかつ編集の時
      //画像削除APIを叩く。新規投稿の時は走らない
      final String result = await APIService.requestDeleteAPI(
          widget.timeline!.id, await ref.watch(userProvider)?.getIdToken());
      if (result != "" && result != "Post not found" && context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('投稿の削除に失敗しました'),
              content: Text(result),
              actions: [
                CupertinoDialogAction(
                  child: const Text('閉じる'),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }
    isAPIRequesting = false;
    //wantToGoフラグがTrueの場合はFalseに変更
    int timelineId = widget.timeline?.id ?? -1;
    if (widget.shop.wantToGoFlg) {
      final shop = Shop()
        ..id = widget.shop.id
        ..shopName = widget.shop.shopName
        ..shopAddress = widget.shop.shopAddress
        ..googlePlaceId = widget.shop.googlePlaceId
        ..shopLatitude = widget.shop.shopLatitude
        ..shopLongitude = widget.shop.shopLongitude
        ..shopMapIconKind = widget.shop.shopMapIconKind
        ..wantToGoFlg = false
        ..createdAt = widget.shop.createdAt
        ..updatedAt = DateTime.now();
      await IsarUtils.createShop(shop);
    }
    if (widget.timeline != null) {
      _updateTimeline();
    } else {
      timelineId = await _addToDB();
      //経験値獲得
      //もしそのお店の初投稿なら100exp獲得
      final int postCnt = await IsarUtils.getTimelinesByShopId(widget.shop.id)
          .then((value) => value.length);
      if (postCnt == 1) {
        if (context.mounted) {
          getAndShowExpDialog(context: context, title: "初投稿ボーナス", exp: 300);
        }
      } else {
        if (context.mounted) {
          getAndShowExpDialog(context: context, title: "投稿ボーナス", exp: 100);
        }
      }
     
    }

    if (isPublic && images.isNotEmpty && timelineId != -1) {
      //画像投稿APIを叩く
      PostAPIRequest req = PostAPIRequest(
        timelineId: timelineId,
        googleMapShopId: widget.shop.googlePlaceId,
        longitude: widget.shop.shopLongitude,
        latitude: widget.shop.shopLatitude,
        star: star,
        name: widget.shop.shopName,
        address: widget.shop.shopAddress,
        imageList: images.map((e) => e.readAsBytesSync()).toList(),
      );
      final String result = await APIService.requestPostAPI(
          req, await ref.watch(userProvider)?.getIdToken());
      if (result != "" && context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('投稿に失敗しました'),
              content: Text(result),
              actions: [
                CupertinoDialogAction(
                  child: const Text('閉じる'),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    } 
  }

  //DBに投稿を追加
  Future<int> _addToDB() async {
    List<String> imagePathList = [];
    for (var image in images) {
      String? imagePath = await saveImageFile(image);
      if (imagePath != null) {
        imagePathList.add(imagePath);
      }
    }
    final timeline = Timeline()
      ..images = imagePathList
      ..comment = comment
      ..star = star
      ..isPublic = isPublic
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..shopId = widget.shop.id
      ..date = date;
    await IsarUtils.createTimeline(timeline);

    if (context.mounted) {
      //振動
      Haptic.onSuccess();
      Navigator.pop(context);
      return timeline.id;
    }
    return -1;
  }

  //DBの投稿を更新
  Future<void> _updateTimeline() async {
    List<String> imagePathList = [];
    for (var image in images) {
      String? imagePath = await saveImageFile(image);
      if (imagePath != null) {
        imagePathList.add(imagePath);
      }
    }
    final timeline = Timeline()
      ..id = widget.timeline!.id
      ..images = imagePathList
      ..comment = comment
      ..star = star
      ..isPublic = isPublic
      ..createdAt = widget.timeline!.createdAt
      ..updatedAt = DateTime.now()
      ..shopId = widget.shop.id
      ..date = date;
    await IsarUtils.createTimeline(timeline);

    if (context.mounted) {
      //振動
      Haptic.onSuccess();
      Navigator.pop(context);
      return;
    }
  }
}

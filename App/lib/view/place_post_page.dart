import 'dart:io';

import 'package:flutter/Cupertino.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_haptic/haptic.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/component/post_food_widget.dart';
import 'package:gohan_map/utils/common.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/place_detail_page.dart';
import 'package:path/path.dart' as p;

import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';

// 飲食店でのごはん投稿・編集画面
class PlacePostPage extends StatefulWidget {
  final Shop shop;
  final Timeline? timeline; // 編集ページの際に外部から初期データを渡す

  const PlacePostPage({Key? key, required this.shop, this.timeline})
      : super(key: key);

  @override
  State<PlacePostPage> createState() => _PlacePostPageState();
}

class _PlacePostPageState extends State<PlacePostPage> {
  List<File> images = [];
  DateTime date = DateTime.now();
  String comment = '';
  double star = 4.0;
  bool isPublic = false;
  bool avoidkeyBoard = false;
  bool isLoading = true;

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
      }
      setState(() {
        // reload
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

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
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: () {
                  onTapComfirm(context);
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
  void onTapComfirm(BuildContext context) {
    //バリデーション
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

    if (isPublic) {
      //TODO:画像投稿APIを叩く
    } else if (widget.timeline != null) {
      //TODO:画像削除APIを叩く
    }
    Future(() async {
      //wantToGoフラグがTrueの場合はFalseに変更
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
        _addToDB();
      }
    });
  }

  //DBに投稿を追加
  Future<void> _addToDB() async {
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
      return;
    }
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

import 'dart:io';

import 'package:flutter/Cupertino.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gohan_map/collections/shop.dart';

import 'package:gohan_map/utils/map_pins.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:latlong2/latlong.dart';

import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';

//飲食店の登録画面
class PlaceCreatePage extends StatefulWidget {
  final LatLng latlng;
  final String? shopName;
  final String placeId;
  final String address;
  const PlaceCreatePage(
      {Key? key,
      required this.latlng,
      this.shopName,
      required this.placeId,
      required this.address})
      : super(key: key);

  @override
  State<PlaceCreatePage> createState() => _PlaceCreatePageState();
}

class _PlaceCreatePageState extends State<PlaceCreatePage> {
  String shopMapIconKind = "default";
  File? image;
  double star = 4.0;
  DateTime date = DateTime.now();
  String comment = '';
  bool avoidkeyBoard = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      initialChildSize: 0.6,
      maxChildSize: 0.7,
      avoidKeyboardFlg: avoidkeyBoard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _ShopNameArea(
                  shopName: widget.shopName ?? "名称未設定",
                  shopAddress: widget.address,
                ),
                const Positioned(
                  top: -12,
                  left: 16,
                  child: NewBudge(),
                ),
              ],
            ),
          
            // ピンの種類
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'お店のジャンル',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  DropdownButton(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 4,
                    items: [
                      for (var v in mapPins)
                        DropdownMenuItem(
                          value: v.kind,
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 40,
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  v.pinImagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(v.displayName),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(
                        () {
                          shopMapIconKind = value;
                        },
                      );
                    },
                    value: shopMapIconKind,
                  ),
                ],
              ),
            ),

            //行きたいボタン
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 12),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  foregroundColor: AppColors.blackTextColor,
                  backgroundColor: AppColors.whiteColor,
                ),
                onPressed: () {
                  //行ってみたいお店として登録
                  _onTapComfirm(context, true);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '行ってみたいお店として登録',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            //登録ボタン
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 12),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: AppColors.blackTextColor,
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: () {
                  //行ったお店として登録
                  _onTapComfirm(context, false);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '行ったお店として登録',
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            // キャンセルボタン
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 12, bottom: 24),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //決定ボタンを押した時の処理
  void _onTapComfirm(BuildContext context, bool wantToGoFlg) {
    _addToDB(wantToGoFlg);
  }

  //DBに店を登録
  Future<void> _addToDB(bool wantToGoFlg) async {
    final shop = Shop()
      ..shopName = widget.shopName ?? '名称未設定'
      ..shopAddress = widget.address
      ..googlePlaceId = widget.placeId
      ..shopLatitude = widget.latlng.latitude
      ..shopLongitude = widget.latlng.longitude
      ..shopMapIconKind = shopMapIconKind
      ..wantToGoFlg = wantToGoFlg
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    IsarUtils.createShop(shop).then((shopId) {
        if (wantToGoFlg) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('行ってみたいお店として\n登録しました'),
                content: Container(
                  width: 82,
                  height: 82,
                  margin: const EdgeInsets.only(top: 20, bottom: 12),
                  child: SvgPicture.asset(
                    'images/pins/pin_man.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('閉じる'),
                    onPressed: () async {
                      Navigator.pop(context, false);
                    },
                  ),
                ],
              );
            },
          ).then(
            (isInitialPost) {
              if (isInitialPost) {
                Navigator.pop(context, shopId);
              } else {
                Navigator.pop(context);
              }
            },
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('行ったお店として登録しました'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //ピン画像
                    Container(
                      width: 82,
                      height: 82,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: SvgPicture.asset(
                        findPinByKind(shopMapIconKind)?.pinImagePath ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text('早速お店の感想を記録しましょう！'),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('後で行う'),
                    onPressed: () async {
                      Navigator.pop(context, false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      '記録する',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              );
            },
          ).then(
            (isInitialPost) {
              if (isInitialPost) {
                Navigator.pop(context, shopId);
              } else {
                Navigator.pop(context);
              }
            },
          );
        }
      },
    );
  }
}

class _ShopNameArea extends StatelessWidget {
  const _ShopNameArea({
    required this.shopName,
    required this.shopAddress,
  });

  final String shopName;
  final String shopAddress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      //最低限の高さを設定
      constraints: const BoxConstraints(
        minHeight: 160,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 30, 12, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
          color: AppColors.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shopName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.place,
                  color: AppColors.greyDarkColor,
                  size: 20,
                ),
                Flexible(
                  child: Text(
                    shopAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greyDarkColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewBudge extends StatelessWidget {
  const NewBudge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.whiteColor,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor,
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
        color: AppColors.primaryColor,
      ),
      child: const Center(
        child: Text(
          "NEW!!",
          style: TextStyle(
              height: 1.2,
              fontFamily: "SFProRounded",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}

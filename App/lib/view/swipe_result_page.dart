import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_rating_bar.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:latlong2/latlong.dart';

class SwipeResultPage extends StatefulWidget {
  const SwipeResultPage({super.key, required this.candidates});
  final List<CandidateModel> candidates;

  @override
  State<SwipeResultPage> createState() => _SwipeResultPageState();
}

class _SwipeResultPageState extends State<SwipeResultPage> {
  List<CandidateModel> get candidates => widget.candidates;
  @override
  void initState() {
    
    Map<String, int> placeIdToId = {};
    for (var i = 0; i < candidates.length; i++) {
      debugPrint(candidates[i].googlePlaceId);
      //idは同じplaceIdのものは同じになる
      if (placeIdToId.containsKey(candidates[i].googlePlaceId)) {
        candidates[i].id = placeIdToId[candidates[i].googlePlaceId];
      } else {
        //placeIdToIdにない場合は新しくidを割り振る
        //idはできるだけ小さいものにする
        int minId = 0;
        for (var j = 0; j < candidates.length; j++) {
          if (candidates[j].id != null) {
            minId = max(minId, candidates[j].id!);
          }
        }
        candidates[i].id = minId + 1;
        placeIdToId[candidates[i].googlePlaceId] = minId + 1;
      }
      candidates[i].isPicked = false;
    }
    //idでソート
    candidates.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<int> uniqueIds = <int>{};
    int cnt = candidates.where((element) {
      if ((element.isPicked ?? false) && uniqueIds.add(element.id ?? 0)) {
        return true;
      }
      return false;
    }).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipeResMap(
              candidates: candidates,
              minLat: candidates.map((e) => e.latitude).reduce(
                  (value, element) => value < element ? value : element),
              maxLat: candidates.map((e) => e.latitude).reduce(
                  (value, element) => value > element ? value : element),
              minLng: candidates.map((e) => e.longitude).reduce(
                  (value, element) => value < element ? value : element),
              maxLng: candidates.map((e) => e.longitude).reduce(
                  (value, element) => value > element ? value : element),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "行ってみたいお店を選んでください",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  GridView.builder(
                    itemCount: candidates.length,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return _SwipeResCard(
                        candidates: candidates,
                        index: index,
                        onTap: () {
                          for (var i = 0; i < candidates.length; i++) {
                            if (candidates[i].id == candidates[index].id) {
                              setState(() {
                                candidates[i].isPicked!
                                    ? candidates[i].isPicked = false
                                    : candidates[i].isPicked = true;
                              });
                            }
                          }
                          
                        },
                      );
                    },
                  ),
                  //オレンジ色の登録ボタン
                  //TweenAnimationBuilder
                  _RegisterButton(
                    isShow: (candidates.any((element) => element.isPicked!)),
                    cnt:
                        cnt,
                    onPressed: () {
                      //登録ボタンを押したときの処理
                      List<CandidateModel> pickedCandidates = candidates
                          .where((element) => element.isPicked!)
                          .toList();
                      for (var c in pickedCandidates) {
                        //isarに登録
                        IsarUtils.createShop(
                          Shop()
                            ..googlePlaceId = c.googlePlaceId
                            ..shopName = c.name
                            ..shopAddress = c.address
                            ..shopMapIconKind = "default" //アイコンの種類はデフォルト
                            ..wantToGoFlg = true
                            ..shopLatitude = c.latitude
                            ..shopLongitude = c.longitude
                            ..createdAt = DateTime.now()
                            ..updatedAt = DateTime.now(),
                        );
                      }
                      //Cupertinoダイアログ
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text("行ってみたいお店として\n登録しました"),
                            content: const Text("登録したお店はマップから確認することができます。"),
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
                      ).then((value) => Navigator.popUntil(
                          context, (route) => route.isFirst));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    required this.isShow,
    required this.onPressed,
    required this.cnt,
  });
  final int cnt;
  final bool isShow;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: 0, end: isShow ? 1 : 0),
      duration: const Duration(milliseconds: 200),
      builder: (BuildContext context, double value, Widget? child) {
        return Positioned(
          bottom: -50 + 75 * value,
          left: 16,
          right: 16,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
              ),
              onPressed: (isShow) ? onPressed : null,
              child: Stack(
                children: [
                  Text(
                    "$cnt件のお店を登録する",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Opacity(
                    opacity: 1 - value,
                    child: const Text(
                      "登録する",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SwipeResCard extends StatelessWidget {
  const _SwipeResCard({
    required this.candidates,
    required this.index,
    required this.onTap,
  });

  final List<CandidateModel> candidates;
  final int index;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: candidates[index].isPicked!
                ? AppColors.primaryColor
                : Colors.transparent,
            width: 2,
          ),
          color: CupertinoColors.white,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 16 / 9, child: candidates[index].img),
                  Positioned(
                      top: 4,
                      left: 4,
                      child: _NumBudge(
                        size: 20,
                        num: candidates[index].id!,
                      )),
                  //星
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IgnorePointer(
                              ignoring: true,
                              child: AppRatingBar(
                                initialRating: 4,
                                onRatingUpdate: (rating) {},
                                itemSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Text(
                candidates[index].name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
              child: Text(
                candidates[index].address,
                style: const TextStyle(fontSize: 12, height: 1.2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeResMap extends StatelessWidget {
  const SwipeResMap({
    super.key,
    required this.candidates,
    this.minLat,
    this.maxLat,
    this.minLng,
    this.maxLng,
  });
  final List<CandidateModel> candidates;
  final double? minLat;
  final double? maxLat;
  final double? minLng;
  final double? maxLng;

  @override
  Widget build(BuildContext context) {
    //zoomの計算を行う
    double? zoom = 14;
    if (minLat != maxLat &&
        minLng != maxLng &&
        minLat != null &&
        maxLat != null &&
        minLng != null &&
        maxLng != null) {
      final latDiff = maxLat! - minLat!;
      final lngDiff = maxLng! - minLng!;
      var pixelPerLat = 120 / latDiff;
      var pixelPerLng = 240 / lngDiff / cos(maxLat! * pi / 180);
      zoom = log(360 * min(pixelPerLat, pixelPerLng)) / log(2) - 8;
      zoom = min(zoom, 20);
    }
    //centerの計算
    final LatLng? centerLat = (minLat != null && maxLat != null)
        ? LatLng((minLat! + maxLat!) / 2, (minLng! + maxLng!) / 2)
        : null;
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          // マップ表示設定
          options: MapOptions(
            center: centerLat ?? LatLng(35.681, 139.767),
            zoom: zoom,
            interactiveFlags: InteractiveFlag.all,
            enableScrollWheel: true,
            scrollWheelVelocity: 0.00001,
          ),

          children: [
            TileLayer(
              urlTemplate:
                  "https://tile.openstreetmap.jp/styles/maptiler-basic-ja/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: candidates
                  .map(
                    (e) => buildMarker(e),
                  )
                  .toList(),
              rotate: true,
            ),
          ],
        ),
      ),
    );
  }

  Marker buildMarker(CandidateModel e) {
    return Marker(
      width: 30,
      height: 30,
      point: LatLng(e.latitude!, e.longitude!),
      builder: (context) => _NumBudge(
        num: e.id!,
      ),
    );
  }
}

class _NumBudge extends StatelessWidget {
  const _NumBudge({
    required this.num,
    this.size = 20,
  });
  final int num;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.white,
          width: size,
          height: size,
          child: Center(
            child: Text(
              num.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_rating_bar.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:latlong2/latlong.dart';

class SwipeResultPage extends StatefulWidget {
  const SwipeResultPage({super.key, required this.candidates});
  final List<CandidateModel> candidates;

  @override
  State<SwipeResultPage> createState() => _SwipeResultPageState();
}

class _SwipeResultPageState extends State<SwipeResultPage> {
  List<SwipeResult> swipeRes = [];
  void initState() {
    // TODO: implement initState
    for (var i = 0; i < widget.candidates.length; i++) {
      swipeRes.add(
        SwipeResult(
          shopName: "ここに店名ここに店名ここに店名ここに店名ここに店名",
          shopAddress: "ここに住所ここに住所ここに住所ここに住所ここに住所ここに住所",
          shopImg: widget.candidates[i].img!,
          shopRating: widget.candidates[i].star!,
          shopLatLng: LatLng(35.681 + 0.01 * i, 139.767 + 0.01 * i),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipeResMap(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "登録したいお店を選んでください",
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
                    itemCount: widget.candidates.length,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            swipeRes[index].isPicked
                                ? swipeRes[index].isPicked = false
                                : swipeRes[index].isPicked = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: swipeRes[index].isPicked
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: CupertinoColors.white,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.2),
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
                                  top: Radius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: widget.candidates[index].img!),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                              const Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                child: Text(
                                  "ここに店名ここに店名ここに店名ここに店名ここに店名",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(4, 2, 4, 0),
                                child: Text(
                                  "ここに住所ここに住所ここに住所ここに住所ここに住所ここに住所",
                                  style: TextStyle(fontSize: 12),
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
                    },
                  ),
                  //オレンジ色の登録ボタン
                  Positioned(
                    bottom: 16,
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
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SwipeUIPage()),
                          );
                        },
                        child: const Text(
                          "登録する",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
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

class SwipeResMap extends StatelessWidget {
  const SwipeResMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            center: LatLng(35.681, 139.767),
            zoom: 14.0,
            interactiveFlags: InteractiveFlag.all,
            enableScrollWheel: true,
            scrollWheelVelocity: 0.00001,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://tile.openstreetmap.jp/styles/maptiler-basic-ja/{z}/{x}/{y}.png",
            )
          ],
        ),
      ),
    );
  }
}

class SwipeResult {
  final String shopName;
  final String shopAddress;
  final Image shopImg;
  final double shopRating;
  final LatLng shopLatLng;
  bool isPicked = false;

  SwipeResult({
    required this.shopName,
    required this.shopAddress,
    required this.shopImg,
    required this.shopRating,
    required this.shopLatLng,
  });
}

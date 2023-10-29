import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class SwipeUIPrePage extends ConsumerStatefulWidget {
  const SwipeUIPrePage({super.key});

  @override
  ConsumerState<SwipeUIPrePage> createState() => SwipeUIPrePageState();
}

class SwipeUIPrePageState extends ConsumerState<SwipeUIPrePage> {
  void reload() {}
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "Swipe",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Image.asset(
                        "images/swipe_howto.png",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Text(
                      "他のユーザが投稿した、あなたの地域のおすすめの飲食店が紹介されます。気になったものを選んでマップに追加しましょう。",
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHintBtn(context),
                  _buildStartBtn(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //ヒントボタン
  Container _buildHintBtn(context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      height: 50,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.primaryColor),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return AppModal(
                  maxChildSize: 300 / MediaQuery.of(context).size.height,
                  minChildSize: 300 / MediaQuery.of(context).size.height,
                  initialChildSize: 300 / MediaQuery.of(context).size.height,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                        child: Text(
                          "1.気になったお店を右スワイプ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                        child: Text(
                          "ご飯の写真を確認して、気になったお店を右スワイプ、そうでないお店は左スワイプしましょう",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: Text(
                          "2.マップに登録したいお店を選択",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                        child: Text(
                          "気になった写真のお店の中から、マップに登録して実際に行ってみたいお店を選択しましょう",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: Text(
                          "3.実際に行ってみましょう",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Text(
                          "行ってみたいお店に実際に訪問して、自分だけの\"UMAP\"を広げましょう",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ヒント',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //スタートボタン
  Container _buildStartBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: (isLoading)
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                var currentLocation = await getCurrentLocation();
                var (result, msg) = await APIService.requestSwipeAPI(
                    currentLocation,
                    10000000,
                    await ref.watch(userProvider)?.getIdToken());
                if (msg != "" && mounted) {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            "エラー",
                          ),
                          content: Text(msg),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                                return;
                              },
                            ),
                          ],
                        );
                      });
                } else if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SwipeUIPage(
                              results: result,
                            )),
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            const Text(
              '近くのおすすめ飲食店を探す',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<LatLng> getCurrentLocation() async {
    //現在地を取得
    LatLng? currentLocation;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 2));
      currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      if (context.mounted) {
        await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("現在地取得失敗"),
                content: const Text("現在地を取得できませんでした。\n札幌駅周辺を検索します。"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                  ),
                ],
              );
            });
      }
    }
    return currentLocation ?? LatLng(43.068564, 141.3507138); //札幌駅の緯度経度
  }
}

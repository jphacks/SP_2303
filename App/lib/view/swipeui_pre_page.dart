import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('SwipeUI'),
                onPressed: () async {
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
                },
              ),
            ],
          ),
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

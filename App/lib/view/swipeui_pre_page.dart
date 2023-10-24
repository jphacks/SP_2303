import 'package:flutter/material.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class SwipeUIPrePage extends StatefulWidget {
  const SwipeUIPrePage({super.key});

  @override
  State<SwipeUIPrePage> createState() => SwipeUIPrePageState();
}

class SwipeUIPrePageState extends State<SwipeUIPrePage> {
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
                  //現在地を取得
                  var currentLocation = await getCurrentLocation();
                  await APIService.requestSwipeAPI(currentLocation, 100000, "");
                  if (mounted) {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SwipeUIPage()),
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
    //現在地を取
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    return currentLocation;
  }
}

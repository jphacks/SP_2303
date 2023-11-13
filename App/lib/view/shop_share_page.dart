// ignore: file_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/view/swipe_result_page.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShopSharePage extends StatefulWidget {
  const ShopSharePage({super.key});

  @override
  State<ShopSharePage> createState() => _ShopSharePageState();
}

class _ShopSharePageState extends State<ShopSharePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  ShareQRData sendData = ShareQRData(name: "toyodatoyoda", shareShopList: [
    ShareShop(
        name: "札幌ザンギ本舗 札幌駅北口店",
        address: "札幌市北区北８条西４丁目13−３ 金子ビル 1F",
        googlePlaceId: "ChIJwebc6AYpC18RG0XzoP0uacs",
        latitude: 43.07098430000001,
        longitude: 141.3492699,
        star: 4,
        imageURL: ""),
    ShareShop(
        name: "コメダ珈琲店 北12条東店",
        address: "札幌市東区北１２条東４丁目２−１２",
        googlePlaceId: "ChIJd6mJ6nApC18Red6hUNrolyY",
        latitude: 43.0772478,
        longitude: 141.3591183,
        star: 5,
        imageURL: ""),
    ShareShop(
        name: "山次郎",
        address: "札幌市北区北１３条西４丁目１−５",
        googlePlaceId: "ChIJ5QpeoA8pC18Rh_9InTIvgF8",
        latitude: 43.0759668,
        longitude: 141.3477653,
        star: 5,
        imageURL: ""),
    ShareShop(
        name: "山次郎",
        address: "札幌市北区北１３条西４丁目１−５",
        googlePlaceId: "ChIJ5QpeoA8pC18Rh_9InTIvgF8",
        latitude: 43.0759668,
        longitude: 141.3477653,
        star: 5,
        imageURL: ""),
  ]);
  ShareQRData? receiveData;
  var sendJson = "";
  @override
  void initState() {
    sendJson = jsonEncode(sendData.toJson());
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("交換をはじめます"),
        foregroundColor: AppColors.blackTextColor,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Opacity(
                opacity: 0,
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: SizedBox(
                    width: double.infinity,
                    child: QRView(
                      key: qrKey,
                      cameraFacing: CameraFacing.front,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
              ),
              Column(
                //crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  QrImageView(
                    data: sendJson,
                    version: QrVersions.auto,
                  ),
                  const Divider(),
                  if (receiveData == null) ...[
                    const Text(
                      "おすすめ飲食店を交換したい相手と\nこの画面を20cmの間隔をあけて\n向かい合わせにしてください\nお互いのQRコードをインカメラを使って読み取ります",
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (receiveData != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${receiveData?.name} さん",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                "とおすすめ飲食店を交換しました",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildShowResBtn(context),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //交換結果を見るボタン
  SizedBox _buildShowResBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
        onPressed: () {
          //データ整形
          if (receiveData == null || receiveData!.shareShopList.isEmpty) {
            return;
          }
          List<CandidateModel> candidates = [];
          for (var element in receiveData!.shareShopList) {
            candidates.add(CandidateModel(
                name: element.name,
                address: element.address,
                googlePlaceId: element.googlePlaceId,
                latitude: element.latitude,
                longitude: element.longitude,
                star: element.star,
                img: (element.imageURL == "")
                    ? Image.asset("images/no_image.png")
                    : Image.network(element.imageURL)));
          }
          //SwipeResultページに遷移
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return SwipeResultPage(
              candidates: candidates,
            );
          }));
        },
        child: const Text(
          '交換結果を見る',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController p1) {
    setState(() {
      controller = p1;
    });
    controller!.scannedDataStream.listen((scanData) {
      //Barcode to str
      String str = scanData.code ?? "";
      //str to json
      try {
        Map<String, dynamic> json = jsonDecode(str);
        //json to ShareQRData
        ShareQRData result = ShareQRData.fromJson(json);
        _onQRViewScanned(result);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  //スキャンしたら
  void _onQRViewScanned(ShareQRData scanData) {
    //振動
    HapticFeedback.heavyImpact();
    setState(() {
      receiveData = scanData;
      controller?.pauseCamera();
    });
  }
}

class ShareQRData {
  final List<ShareShop> shareShopList;
  final String name;
  ShareQRData({required this.shareShopList, required this.name});

  factory ShareQRData.fromJson(Map<String, dynamic> data) {
    List<ShareShop> shareShopListResult = [];
    for (var element in data["result"]) {
      shareShopListResult.add(ShareShop.fromJson(element));
    }
    return ShareQRData(shareShopList: shareShopListResult, name: data["name"]);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> shareShopListResult = [];
    for (var element in shareShopList) {
      shareShopListResult.add(element.toJson());
    }
    return {"result": shareShopListResult, "name": name};
  }
}

class ShareShop {
  final String name;
  final String address;
  final String googlePlaceId;
  final double latitude;
  final double longitude;
  final double star;
  final String imageURL;

  ShareShop(
      {required this.name,
      required this.address,
      required this.googlePlaceId,
      required this.latitude,
      required this.longitude,
      required this.star,
      required this.imageURL});

  factory ShareShop.fromJson(Map<String, dynamic> data) {
    String nameResult = data["n"];
    String addressResult = data["a"];
    String shopIdResult = data["i"];
    double latitudeResult = data["la"];
    double longitudeResult = data["lo"];
    double starResult = data["s"];
    String imageResult = data["u"];
    return ShareShop(
        name: nameResult,
        address: addressResult,
        googlePlaceId: shopIdResult,
        latitude: latitudeResult,
        longitude: longitudeResult,
        star: starResult,
        imageURL: imageResult);
  }

  Map<String, dynamic> toJson() {
    return {
      "n": name,
      "a": address,
      "i": googlePlaceId,
      "la": latitude,
      "lo": longitude,
      "s": star,
      "u": imageURL
    };
  }
}

import 'dart:io';
import 'dart:math';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_map.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/utils/map_pins.dart';
import 'package:gohan_map/utils/safearea_utils.dart';
import 'package:gohan_map/view/place_create_page.dart';
import 'package:gohan_map/view/place_detail_page.dart';
import 'package:gohan_map/view/place_post_page.dart';
import 'package:gohan_map/view/place_search_page.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

///地図が表示されている画面
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with TickerProviderStateMixin {
  // Key? keyは、ウィジェットの識別子。ウィジェットの状態を保持するためには必要だが、今回は特に使わない。
  List<Marker> pins = [];
  Map<Id, bool> tapFlgs = {};
  List<Shop> shops = [];
  final MapController mapController = MapController();
  @override
  void initState() {
    super.initState();

    Future(() async {
      await _loadAllShop(); //DBから飲食店の情報を取得してピンを配置

      await Future.delayed(
          const Duration(milliseconds: 500)); // 高速に画面が切り替わることを避ける
      FlutterNativeSplash.remove();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Platform.isAndroid) {
        changeTo120fps();
      }
    });
  }

  void reload() {
    Future(() async {
      await _loadAllShop(); //DBから飲食店の情報を取得してピンを配置

      await Future.delayed(
          const Duration(milliseconds: 500)); // 高速に画面が切り替わることを避ける
      FlutterNativeSplash.remove();
    });
  }

  Future<void> changeTo120fps() async {
    try {
      FlutterDisplayMode.setHighRefreshRate();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: AppMap(
            pins: pins,
            mapController: mapController,
          ),
        ),
        buildDummySearchWidget(),
      ],
    );
  }

  //下の検索バー
  Widget buildDummySearchWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          child: AbsorbPointer(
            child: Container(
              //モーダル風UIの中身
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow:
                    [BoxShadow(blurRadius: 16, color: Colors.black.withOpacity(0.2))],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: AppColors.greyColor,
                              width: 1,
                            ),
                        ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.primaryColor
                        ),
                        child: const Icon(AppIcons.search, color: AppColors.whiteColor,),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text("お店の 検索 / 登録",style: TextStyle(color: Colors.black38,),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            //検索バーをタップしたときの処理
            showModalBottomSheet(
              barrierColor: Colors.black.withOpacity(0),
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return PlaceSearchPage(
                  mapController: mapController,
                ); //飲食店を検索する画面
              },
            ).then(
              (value) {
                //valueの型がInt→詳細画面
                //int型ならそのまま、Id型ならばnullにしたい
                int? id = (value is int) ? value : null;
                //valueの型がPlaceApiRestaurantResult→新規作成画面
                PlaceApiRestaurantResult? paResult =
                    (value is PlaceApiRestaurantResult) ? value : null;

                //検索画面で追加済みの店を選択した場合、選択した場所の詳細画面を表示する。
                if (id != null) {
                  setState(() {
                    tapFlgs[id] = true;
                  });
                  showModalBottomSheet(
                    barrierColor: Colors.black.withOpacity(0),
                    context: context,
                    isDismissible: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return PlaceDetailPage(
                        id: id,
                      ); //飲食店の詳細画面
                    },
                  ).then((value) => _onModalPop(value, id));
                  //ピンの緯度経度を取得
                  IsarUtils.getShopById(id).then((shop) {
                    if (shop != null) {
                      final latLng =
                          LatLng(shop.shopLatitude, shop.shopLongitude);
                      //ピンの位置に移動する
                      final deviceHeight = MediaQuery.of(context).size.height;
                      _moveToPin(latLng, (deviceHeight - 150) * 0.2);
                    }
                  });
                }

                //検索画面で新規店舗を選択した場合、新規作成画面を表示する。
                if (paResult != null) {
                  setState(() {
                    //ピンを配置する
                    _addPinToMap(paResult.latlng, null);
                  });
                  //mapをスクロールする
                  final deviceHeight = MediaQuery.of(context).size.height;
                  _moveToPin(paResult.latlng, (deviceHeight - 150) * 0.2);
                  showModalBottomSheet(
                    barrierColor: Colors.black.withOpacity(0),
                    isDismissible: true,
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return PlaceCreatePage(
                        latlng: paResult.latlng,
                        shopName: paResult.name,
                        placeId: paResult.placeId,
                        address: paResult.address,
                      );
                    },
                  ).then((shopId) {
                    _loadAllShop();
                    if (shopId != null) {
                      //ピンの位置に移動する
                      IsarUtils.getShopById(shopId).then((shop) {
                        if (shop != null) {
                          final latLng =
                              LatLng(shop.shopLatitude, shop.shopLongitude);
                          _moveToPin(latLng, (deviceHeight - 150) * 0.2);
                          //初回投稿
                          showModalBottomSheet(
                            barrierColor: Colors.black.withOpacity(0),
                            isDismissible: true,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return PlacePostPage(
                                shop: shop,
                              );
                            },
                          );
                        }
                      });
                    }
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }

  //1つのピンを、地図に描画するための配列pinsに追加する関数
  void _addPinToMap(LatLng latLng, Shop? shop) {
    const markerSize = 44.0;
    const imgRatio = 405 / 512;
    final shopMapPin = findPinByKind(shop?.shopMapIconKind);
    pins.add(
      Marker(
        width: markerSize * imgRatio,
        height: markerSize,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        point: latLng,
        builder: (context) {
          //ラベルの表示判定に利用する文字長
          int? textLen = shop?.shopName
              .replaceAll(RegExp(r'[^\x00-\x7F]'), '  ')
              .length; //ASCII文字:1文字分、日本語:2文字分
          //ピンのデザイン
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.diagonal3Values(
                tapFlgs[shop?.id] == true ? 1.3 : 1,
                tapFlgs[shop?.id] == true ? 1.3 : 1,
                1),
            transformAlignment: Alignment.bottomCenter,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  //ピンをタップしたときの処理
                  if (shop != null) {
                    //マップを自動スクロールする
                    final deviceHeight = MediaQuery.of(context).size.height;
                    _moveToPin(latLng, (deviceHeight - 150) * 0.2);
                    HapticFeedback.heavyImpact();
                    //300ms後にモーダルを表示する
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        tapFlgs[shop.id] = true;
                      });
                      //Heroアニメーションに対応したモーダル
                      showMaterialModalBottomSheet(
                        barrierColor: Colors.black.withOpacity(0),
                        isDismissible: true,
                        duration: const Duration(milliseconds: 250),
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return PlaceDetailPage(
                            id: shop.id,
                          ); //飲食店の詳細画面
                        },
                      ).then((value) => _onModalPop(value, shop.id));
                    });
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(shopMapPin != null
                        ? (shop?.wantToGoFlg ?? false)
                            ? 'images/pins/pin_man.svg'
                            : shopMapPin.pinImagePath
                        : 'images/pins/pin_default.svg'),
                    if (shop != null &&
                        shopMapPin != null &&
                        _isShowShopName(shop, shops, textLen ?? 0))
                      Positioned(
                        left: 38,
                        top: 10,
                        child: BorderedText(
                          strokeWidth: 2,
                          strokeColor: AppColors.whiteColor,
                          child: Text(
                            shop.shopName,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: (shop.wantToGoFlg)
                                    ? AppColors.tabBarColor
                                    : shopMapPin.textColor),
                          ),
                        ),
                      )
                  ],
                )),
          );
        },
      ),
    );
  }

  //ピンにラベルを表示するかを判定する関数
  bool _isShowShopName(Shop shop, List<Shop> shops, int textLen) {
    //例外処理
    var zoom = 15.0;
    var rot = 0.0;
    var rtnFlg = true;
    try {
      zoom = mapController.zoom;
      rot = mapController.rotation;
    } finally {
      //1ピクセルあたりの緯度経度
      var pixelPerLat = pow(2, zoom + 8) / 360;
      var pixelPerLng =
          pow(2, zoom + 8) / 360 * cos(shop.shopLatitude * pi / 180);
      for (var s in shops) {
        if (s.id != shop.id) {
          //上下左右20,20,0,100pxの範囲に他のピンがある場合はラベルを表示しない
          //緯度経度の差を計算
          final latDiff = s.shopLatitude - shop.shopLatitude;
          final lngDiff = s.shopLongitude - shop.shopLongitude;
          //マップの回転を考慮しピクセルの差を計算
          final pixelHDiff = latDiff * pixelPerLat * cos(rot * pi / 180) -
              lngDiff * pixelPerLng * sin(rot * pi / 180);
          final pixelWDiff = latDiff * pixelPerLat * sin(rot * pi / 180) +
              lngDiff * pixelPerLng * cos(rot * pi / 180);
          if (pixelHDiff < 10 &&
              pixelHDiff > -10 &&
              pixelWDiff < textLen * 5 &&
              pixelWDiff > 0) {
            rtnFlg = false;
            break;
          }
        }
      }
    }

    return rtnFlg;
  }

  //DBから飲食店の情報を全て取得してピンを配置する関数。ラベルの表示するかも判定する。
  Future<void> _loadAllShop() async {
    shops = await IsarUtils.getAllShops();
    pins = [];
    tapFlgs = {};
    for (var shop in shops) {
      tapFlgs.addAll({shop.id: false});
      _addPinToMap(LatLng(shop.shopLatitude, shop.shopLongitude), shop);
    }
    setState(() {
      // reload
    });
  }

  //modalから戻ってきたときに実行される関数
  void _onModalPop(dynamic value, int id) {
    //ピンの位置に移動する
    IsarUtils.getShopById(id).then((shop) {
      if (shop != null) {
        final latLng = LatLng(shop.shopLatitude, shop.shopLongitude);

        final deviceHeight = MediaQuery.of(context).size.height;
        _moveToPin(latLng, deviceHeight * 0.1);
      }
    });
    setState(() {
      tapFlgs[id] = false;
      _loadAllShop();
    });
  }

  //ピンの位置に移動する。offsetはピンを画面の中央から何dp上にずらして表示するか
  void _moveToPin(LatLng pinLocation, double offset) {
    var zoom = mapController.zoom;
    var rot = mapController.rotation;
    //1ピクセルあたりの緯度経度
    var pixelPerLat = pow(2, zoom + 8) / 360;
    var pixelPerLng =
        pow(2, zoom + 8) / 360 * cos(pinLocation.latitude * pi / 180);
    //ピンの位置から下へ移動する
    var lat =
        pinLocation.latitude - (offset / pixelPerLat * cos(rot * pi / 180));
    var lng =
        pinLocation.longitude + (offset / pixelPerLng * sin(rot * pi / 180));
    _animatedMapMove(LatLng(lat, lng), zoom);
  }

  //flutter_mapにはアニメーションありのmoveメソッドがないため、AnimationControllerで作成
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}

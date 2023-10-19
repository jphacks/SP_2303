import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gohan_map/collections/search_history.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:latlong2/latlong.dart';

import '../component/app_search_bar.dart';

class PlaceSearchPage extends StatefulWidget {
  final MapController mapController;

  //StatefulWidgetは状態を持つWidget。検索結果を表示するために必要。
  const PlaceSearchPage({Key? key, required this.mapController})
      : super(key: key);

  @override
  State<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage>
    with TickerProviderStateMixin {
  String searchText = "";
  bool isLoadingPlaceApi = false;
  bool showHistory = true; //検索履歴を表示するか
  List<SearchHistory> searchHistoryList = [];
  List<RestaurantResult> restaurants = [];
  TextEditingController controller = TextEditingController();
  late TabController tabController;
  bool filterRegistered = false; //登録済みのみ表示するか
  LatLng? currentLatLng; //現在地

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // TabBarViewは要素の高さが固定出なければいけないので、使用しない
    tabController.addListener(() {
      setState(() {
        // render
      });
    });
    Future(() async {
      searchHistoryList = await IsarUtils.getAllSearchHistories();
      setState(() {
        // reload
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      showKnob: false,
      initialChildSize: 0.9,
      child: Padding(
        //余白を作るためのウィジェット
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 28), //左右に16pxの余白を作る
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //検索バー
            AppSearchBar(
              controller: controller,
              autofocus: true,
              onPressClear: () {
                setState(() {
                  searchText = "";
                  controller.clear();
                });
              },
              onChanged: (text) {
                searchText = text;
              },
              onSubmitted: (text) {
                // APIを叩く回数を減らすため、決定時のみ発火する
                _searchRestaurantsByGoogleApi();
              },
            ),
            const SizedBox(
              height: 20,
            ),

            if (!showHistory) ...[
              RegisteredFilterButton(onChanged: (value) {
                setState(() {
                  filterRegistered = value;
                });
              }),
              const SizedBox(
                height: 20,
              ),
            ],
            //履歴
            if (showHistory)
              HistoryArea(
                searchHistories: searchHistoryList,
              ),
            // 検索結果
            if (!showHistory)
              SearchResultArea(
                restaurantList: restaurants,
                isLoading: isLoadingPlaceApi,
                filterRegistered: filterRegistered,
                currentLatlng: currentLatLng,
              ),
          ],
        ),
      ),
    );
  }

  void _searchRestaurantsByGoogleApi() async {
    if (searchText == "") return; // 空文字ではリクエストを送らない
    setState(() {
      showHistory = false;
      isLoadingPlaceApi = true;
      restaurants = [];
    });
    // 検索結果を取得
    var apiResult = await searchRestaurantsByGoogleMapApi(
      searchText,
      LatLng(widget.mapController.center.latitude,
          widget.mapController.center.longitude),
    );
    List<RestaurantResult> restaurantTmp = [];
    for (var restaurant in apiResult) {
      var shop = await IsarUtils.getShopByGooglePlaceId(restaurant.placeId);
      if (shop != null) {
        restaurantTmp
            .add(RestaurantResult(apiResult: restaurant, isRegistered: true));
      } else {
        restaurantTmp
            .add(RestaurantResult(apiResult: restaurant, isRegistered: false));
      }
    }
    //現在位置を取得
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 3));
      currentLatLng = LatLng(position.latitude, position.longitude);
    } catch (e) {
      logger.d("現在地取得失敗");
    }
    logger.d("API呼び出し");
    setState(() {
      isLoadingPlaceApi = false;
      restaurants = restaurantTmp;
    });
  }
}

class SearchResultArea extends StatelessWidget {
  final List<RestaurantResult> restaurantList;
  final bool isLoading;
  final bool filterRegistered;
  final LatLng? currentLatlng;

  const SearchResultArea(
      {Key? key,
      required this.restaurantList,
      required this.isLoading,
      this.filterRegistered = false,
      this.currentLatlng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )),
        if (!isLoading && restaurantList.isEmpty)
          const Align(
            alignment: Alignment.center,
            child: Text("検索結果はありません"),
          ),
        for (var shop in restaurantList)
          if (!filterRegistered || shop.isRegistered) ...[
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              child: InkWell(
                onTap: () async {
                  //検索結果をタップしたときの処理
                  //検索履歴に追加
                  final history = SearchHistory()
                    ..name = shop.apiResult.name
                    ..address = shop.apiResult.address
                    ..placeId = shop.apiResult.placeId
                    ..latitude = shop.apiResult.latlng.latitude
                    ..longitude = shop.apiResult.latlng.longitude
                    ..updatedAt = DateTime.now()
                    ..createdAt = DateTime.now();
                  await IsarUtils.addSearchHistory(history);
                  if (shop.isRegistered) {
                    //idを返す
                    Shop? s = await IsarUtils.getShopByGooglePlaceId(
                        shop.apiResult.placeId);
                    if (s != null && context.mounted) {
                      Navigator.pop(context, s.id);
                    }
                  } else {
                    //ApiResultを返す
                    if (context.mounted) {
                      Navigator.pop(context, shop.apiResult);
                    }
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        //アイコン
                        const SizedBox(
                          //角丸四角形
                          width: 30,
                          height: 34,
                          child: Icon(
                            AppIcons.map_marker_alt,
                            size: 28,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          _calcDistance(shop.apiResult.latlng),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            shop.apiResult.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                          Text(
                            shop.apiResult.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyDarkColor,
                              height: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
                            child:
                                _RegisterBudge(isRegistered: shop.isRegistered),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
      ],
    );
  }

  //現在地からの距離をテキストで返す
  String _calcDistance(LatLng latlng) {
    if (currentLatlng == null) return "";
    double distance = distanceBetween(
      currentLatlng!.latitude,
      currentLatlng!.longitude,
      latlng.latitude,
      latlng.longitude,
    );
    if (distance < 1000) {
      return "${distance.toStringAsFixed(0)}m";
    } else {
      return "${(distance / 1000).toStringAsFixed(1)}km";
    }
  }

  //2点の緯度経度間の距離を計算
  double distanceBetween(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    toRadians(double degree) => degree * pi / 180;
    const double r = 6378137.0; // 地球の半径
    final double f1 = toRadians(latitude1);
    final double f2 = toRadians(latitude2);
    final double l1 = toRadians(longitude1);
    final double l2 = toRadians(longitude2);
    final num a = pow(sin((f2 - f1) / 2), 2);
    final double b = cos(f1) * cos(f2) * pow(sin((l2 - l1) / 2), 2);
    final double d = 2 * r * asin(sqrt(a + b));
    return d;
  }
}

//履歴エリア
class HistoryArea extends StatelessWidget {
  final List<SearchHistory> searchHistories;
  const HistoryArea({Key? key, required this.searchHistories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var history in searchHistories) ...[
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: InkWell(
              onTap: () async {
                //検索結果をタップしたときの処理
                //検索履歴に追加
                final h = SearchHistory()
                  ..name = history.name
                  ..address = history.address
                  ..placeId = history.placeId
                  ..latitude = history.latitude
                  ..longitude = history.longitude
                  ..updatedAt = DateTime.now()
                  ..createdAt = DateTime.now();
                await IsarUtils.addSearchHistory(h);
                bool isRegistered =
                    (await IsarUtils.getShopByGooglePlaceId(history.placeId) !=
                        null);
                if (isRegistered) {
                  //idを返す
                  Shop? s =
                      await IsarUtils.getShopByGooglePlaceId(history.placeId);
                  if (s != null && context.mounted) {
                    Navigator.pop(context, s.id);
                  }
                } else {
                  //ApiResultを返す
                  if (context.mounted) {
                    PlaceApiRestaurantResult res = PlaceApiRestaurantResult(
                      name: history.name,
                      address: history.address,
                      placeId: history.placeId,
                      latlng: LatLng(history.latitude, history.longitude),
                    );
                    Navigator.pop(context, res);
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    children: [
                      //アイコン
                      SizedBox(
                        //角丸四角形
                        width: 22,
                        height: 22,
                        child: Icon(
                          AppIcons.clock,
                          size: 22,
                          color: AppColors.greyDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          history.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          history.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.greyDarkColor),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ],
    );
  }
}

//登録済みボタン
class RegisteredFilterButton extends StatefulWidget {
  const RegisteredFilterButton({
    super.key,
    this.initialIsUmai,
    required this.onChanged,
  });

  final bool? initialIsUmai;
  final Function(bool) onChanged;

  @override
  State<RegisteredFilterButton> createState() => _RegisteredFilterButtonState();
}

class _RegisteredFilterButtonState extends State<RegisteredFilterButton> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialIsUmai ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: (isOn)
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: (isOn) ? 3 : 0,
          backgroundColor:
              (isOn) ? AppColors.primaryColor : AppColors.whiteColor, //色
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  (isOn) ? AppColors.primaryColor : AppColors.greyDarkColor, //色
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          setState(() {
            isOn = !isOn;
            widget.onChanged(isOn);
          });
        },
        child: Container(
          //角丸四角形
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '# 登録済み',
                style: TextStyle(
                  color:
                      (isOn) ? AppColors.whiteColor : AppColors.greyDarkColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//登録可否バッジ
class _RegisterBudge extends StatelessWidget {
  final bool isRegistered;
  const _RegisterBudge({super.key, required this.isRegistered});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: (isRegistered) ? AppColors.redTextColor : AppColors.greyColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (isRegistered) ? 8 : 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRegistered)
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.whiteColor,
              ),
            Text(
              (isRegistered) ? '登録済み' : '未登録',
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//検索結果
class RestaurantResult {
  late PlaceApiRestaurantResult apiResult;
  late bool isRegistered;
  RestaurantResult({required this.apiResult, required this.isRegistered});
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/utils/isar_utils.dart';

enum ToggleState { visited, wantToGo }

class PlaceListPage extends StatefulWidget {
  final MapController mapController;

  //StatefulWidgetは状態を持つWidget。検索結果を表示するために必要。
  const PlaceListPage({Key? key, required this.mapController})
      : super(key: key);

  @override
  State<PlaceListPage> createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage>
    with TickerProviderStateMixin {
  bool isLoadingPlaceApi = false;
  List<Shop>? allShops;
  ToggleState toggleState = ToggleState.wantToGo; //行った店 or 行ってみたい店

  @override
  void initState() {
    super.initState();
    () async {
      List<Shop> shops = await IsarUtils.getAllShops();
      setState(() {
        allShops = shops;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      showKnob: true,
      initialChildSize: 0.9,
      child: Padding(
        //余白を作るためのウィジェット
        padding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 0), //左右に16pxの余白を作る
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.format_list_bulleted,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "店舗一覧",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CupertinoSlidingSegmentedControl(
                  backgroundColor: AppColors.greyColor,
                  thumbColor: AppColors.whiteColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  groupValue: toggleState,
                  onValueChanged: (ToggleState? value) {
                    setState(() {
                      toggleState = value ?? ToggleState.visited;
                    });
                  },
                  children: const {
                    ToggleState.visited: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "行ったお店",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    ToggleState.wantToGo: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "行ってみたいお店",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  },
                ),
              ),
            ),
            // リスト結果
            ListResultArea(
              shopList: allShops ?? [],
              isLoading: isLoadingPlaceApi,
              wantToGoFlg: toggleState == ToggleState.wantToGo,
            ),
          ],
        ),
      ),
    );
  }
}

class ListResultArea extends StatelessWidget {
  final List<Shop> shopList;
  final bool isLoading;
  final bool wantToGoFlg;

  const ListResultArea({
    Key? key,
    required this.shopList,
    required this.isLoading,
    required this.wantToGoFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Shop> filteredShops = shopList
        .where((element) => element.wantToGoFlg == wantToGoFlg)
        .toList();

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
        if (!isLoading && shopList.isEmpty)
          const Align(
            alignment: Alignment.center,
            child: Text("登録された店舗はありません"),
          ),
        for (var shop in filteredShops) ...[
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: InkWell(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    children: [
                      //アイコン
                      SizedBox(
                        //角丸四角形
                        width: 30,
                        child: Icon(
                          AppIcons.map_marker_alt,
                          size: 28,
                          color: AppColors.primaryColor,
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
                          height: 8,
                        ),
                        Text(
                          shop.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          shop.shopAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.greyDarkColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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

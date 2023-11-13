import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/shop_share_page.dart';
import 'package:gohan_map/view/swipe_result_page.dart';

class ShopShareSelectPage extends ConsumerStatefulWidget {
  //StatefulWidgetは状態を持つWidget。検索結果を表示するために必要。
  const ShopShareSelectPage({Key? key}) : super(key: key);
  final int maxSelectNum = 4;
  @override
  ConsumerState<ShopShareSelectPage> createState() =>
      _ShopShareSelectPageState();
}

class _ShopShareSelectPageState extends ConsumerState<ShopShareSelectPage> {
  List<Shop> shopList = [];
  List<bool> selectedList = [];
  @override
  void initState() {
    super.initState();

    () async {
      List<Shop> shops = await IsarUtils.getAllShops();
      setState(() {
        shopList = shops;
        selectedList = List.generate(shopList.length, (index) => false);
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("友達に教えたいお店を選択"),
        foregroundColor: AppColors.blackTextColor,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Container(
        color: AppColors.whiteColor,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: _ListArea(
                maxSelectNum: widget.maxSelectNum,
                shopList: shopList,
                selectedList: selectedList,
                wantToGoFlg: false,
                onTap: (int index) {
                  if (widget.maxSelectNum >
                          selectedList.where((element) => element).length ||
                      selectedList[index]) {
                    setState(() {
                      selectedList[index] = !selectedList[index];
                    });
                  }
                },
              ),
            ),
            BottomButton(
              text:
                  "${selectedList.where((element) => element).length}件のお店を交換する",
              isShow: (selectedList.any((element) => element)),
              cnt: selectedList.where((element) => element).length,
              onPressed: onPressConfirm,
            ),
          ],
        ),
      ),
    );
  }

  //交換するお店を決定したら
  Future<void> onPressConfirm() async {
    List<ShareShop> selectedShops = [];
    for (var i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) {
        selectedShops.add(
          ShareShop(
            name: shopList[i].shopName,
            address: shopList[i].shopAddress,
            googlePlaceId: shopList[i].googlePlaceId,
            latitude: shopList[i].shopLatitude,
            longitude: shopList[i].shopLongitude,
            star: 0,
            imageURL: "",
          ),
        );
      }
    }
    final (apiRes, msg) = await APIService.requestAnonymousAPI(
        await ref.watch(userProvider)?.getIdToken());
    if (msg != "") {
      CupertinoAlertDialog(
        title: const Text("エラー"),
        content: Text(msg),
        actions: [
          CupertinoDialogAction(
            child: Text(msg),
            onPressed: () {
              Navigator.pop(context);
              return;
            },
          ),
        ],
      );
    }
    for (var shop in selectedShops) {
      //googleIdが一致する店舗を探す
      var result = apiRes
          .where((element) => element.googleMapShopId == shop.googlePlaceId)
          .toList();
      if (result.isNotEmpty && result[0].imageList.isNotEmpty) {
        final imgURL = result[0].imageList[0].imageURL;
        //https://gohanmap.almikan.com/media/images/anonymous-post/を消す
        shop.imageURL = imgURL.replaceAll(
            "https://gohanmap.almikan.com/media/images/anonymous-post/", "");
        shop.star = result[0].star;
      }
    }
    User? user = ref.watch(userProvider);
    //名前
    final String name = user?.displayName ?? "匿名";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopSharePage(
          sendData: ShareQRData(name: name, shareShopList: selectedShops),
        ),
      ),
    );
  }
}

class _ListArea extends StatelessWidget {
  final List<Shop> shopList;
  final List<bool> selectedList;
  final Function(int index) onTap;
  final bool wantToGoFlg;
  final num maxSelectNum;

  const _ListArea({
    Key? key,
    required this.shopList,
    required this.selectedList,
    required this.onTap,
    required this.wantToGoFlg,
    required this.maxSelectNum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Shop> filteredShops = shopList
        .where((element) => element.wantToGoFlg == wantToGoFlg)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filteredShops.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "最大$maxSelectNum店舗まで選択できます",
            style: TextStyle(fontSize: 14, color: AppColors.greyDarkColor),
          ),
        ),
        if (filteredShops.isEmpty)
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("行った店舗はありません"),
            ),
          ),
        for (var shop in filteredShops) ...[
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: InkWell(
                onTap: () {
                  onTap(shopList.indexOf(shop));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                      ),
                      if (selectedList[shopList.indexOf(shop)])
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.primaryColor,
                          size: 28,
                        ),
                      if (!selectedList[shopList.indexOf(shop)])
                        const Icon(Icons.circle_outlined,
                            color: AppColors.greyDarkColor, size: 28),
                      const SizedBox(
                        width: 20,
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

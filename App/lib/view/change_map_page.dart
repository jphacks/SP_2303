import 'package:flutter/material.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeMapPage extends StatefulWidget {
  final String currentTileURL;
  const ChangeMapPage({Key? key, required this.currentTileURL})
      : super(key: key);

  @override
  State<ChangeMapPage> createState() => _ChangeMapPageState();
}

class _ChangeMapPageState extends State<ChangeMapPage> {
  List<MapTile> maptiles = [];

  @override
  void initState() {
    super.initState();
    //地図デザインを追加
    maptiles.add(const MapTile(
        name: "Maptiler Basic",
        url:
            "https://tile.openstreetmap.jp/styles/maptiler-basic-ja/{z}/{x}/{y}.png"));
    maptiles.add(const MapTile(
        name: "OSM OpenMapTiles",
        url: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png"));
    maptiles.add(const MapTile(
        name: "Bright", url: "https://tile.openstreetmap.jp/{z}/{x}/{y}.png"));
    maptiles.add(const MapTile(
        name: "Toner",
        url:
            "https://tile.openstreetmap.jp/styles/maptiler-toner-ja/{z}/{x}/{y}.png"));
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      showKnob: false,
      initialChildSize: 0.5,
      minChildSize: 0.4,
      child: Padding(
        //余白を作るためのウィジェット
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 28), //左右に16pxの余白を作る
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "地図デザインを変更",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () async {
                   SharedPreferences pref =
                    await SharedPreferences.getInstance();
                    await pref.setString("currentTileURL","https://api.maptiler.com/maps/jp-mierune-streets/256/{z}/{x}/{y}@2x.png?key=j4Xnfvwl9nEzUVlzCdBr");
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                }, child: const Text("xxxxxxx",style: TextStyle(color: Colors.transparent),))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            for (var tile in maptiles)
              Card(
                //影付きの角丸四角形
                elevation: 0, //影を消す
                color: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), //角丸の大きさ
                ),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await pref.setString("currentTileURL", tile.url);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: (tile.url == widget.currentTileURL)
                            ? const Icon(Icons.check)
                            : null,
                      ),
                      Flexible(
                        child: Text(
                          tile.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//地図デザインのクラス
class MapTile {
  final String name;
  final String url;
  final String? credit;
  final String? imgURL;
  const MapTile(
      {required this.name, required this.url, this.credit, this.imgURL});
}

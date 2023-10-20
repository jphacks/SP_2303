import 'package:flutter/Material.dart';
import 'package:gohan_map/collections/shop.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/component/post_card_widget.dart';
import 'package:gohan_map/utils/isar_utils.dart';
import 'package:gohan_map/view/place_post_page.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage(
      {super.key, required this.timeline, this.imageData, required this.shop});
  final Timeline timeline;
  final String? imageData;
  final Shop shop;
  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Timeline timeline;
  late int id;
  @override
  void initState() {
    super.initState();
    timeline = widget.timeline;
    id = timeline.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '投稿詳細',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        //色
        backgroundColor: Colors.white,
      ),
      body: (widget.imageData != null)
          ? Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  width: double.infinity,
                  child: Text(
                    widget.shop.shopName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                PostCardWidget(
                    timeline: timeline,
                    imageData: widget.imageData!,
                    onEditTapped: () {
                      showModalBottomSheet(
                        //モーダルを表示する関数
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true, //スクロールで閉じたりするか
                        builder: (context) {
                          return PlacePostPage(
                            shop: widget.shop,
                            timeline: timeline,
                          ); //ご飯投稿
                        },
                      ).then((value) {
                        if (value == null) {
                          return;
                        }
                        IsarUtils.getTimelineById(id).then((tl) {
                          if (tl == null) {
                            return;
                          }
                          setState(() {
                            timeline = tl;
                          });
                        });
                      });
                    },
                    onDeleteTapped: () {
                      IsarUtils.deleteTimeline(timeline.id);
                      Navigator.pop(context,"delete");
                    }),
              ],
            )
          : Container(),
    );
  }
}

//1投稿分のカード
import 'package:flutter/Cupertino.dart';
import 'package:flutter/Material.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_photos_view.dart';
import 'package:gohan_map/component/app_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.timeline,
    required this.imageData,
    required this.onEditTapped,
    required this.onDeleteTapped,
  });

  final Timeline timeline;
  final String imageData;
  final VoidCallback onEditTapped;
  final VoidCallback onDeleteTapped;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: AppColors.greyDarkColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('yyyy年MM月dd日').format(timeline.date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (!timeline.isPublic)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.lock_rounded,
                            //color: AppColors.greyDarkColor,
                            size: 22,
                          ),
                        ),
                    ],
                  ),
                  PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        onTap: onEditTapped,
                        title: '編集',
                        icon: CupertinoIcons.pencil,
                      ),
                      PullDownMenuItem(
                        onTap: onDeleteTapped,
                        title: '削除',
                        isDestructive: true,
                        icon: CupertinoIcons.delete,
                      ),
                    ],
                    animationBuilder: null,
                    position: PullDownMenuPosition.automatic,
                    buttonBuilder: (_, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      pressedOpacity: 1,
                      child: const Icon(
                        CupertinoIcons.ellipsis,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (timeline.images.isNotEmpty)
              //縦長の場合は正方形にする
              AppPhotosView(timeline: timeline, imageData: imageData),
            if (timeline.images.isNotEmpty && timeline.comment != "")
              const SizedBox(
                height: 12,
              ),
            if (timeline.comment != "")
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    timeline.comment,
                  ),
                ),
              )
          ]),
        ),
        Positioned(
          right: 32,
          child: IgnorePointer(
            ignoring: true,
            child: AppRatingBar(
              initialRating: timeline.star,
              onRatingUpdate: (rating) {},
              itemSize: 32,
            ),
          ),
        )
      ],
    );
  }
}

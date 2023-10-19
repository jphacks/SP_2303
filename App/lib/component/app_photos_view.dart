import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:gohan_map/collections/timeline.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path/path.dart' as p;

// 投稿の写真を表示する部分。最大4枚
class AppPhotosView extends StatelessWidget {
  const AppPhotosView({
    super.key,
    required this.timeline,
    required this.imageData,
  });

  final Timeline timeline;
  final String imageData;

  @override
  Widget build(BuildContext context) {
    int imageCount = timeline.images.length;
    List<int> imgNum = [];
    //0 1
    //2 3
    //の順で画像を表示するときに何番目の画像を表示するかを決める
    switch (imageCount) {
      case 1:
        imgNum = [0, 0, 0, 0];
        break;
      case 2:
        imgNum = [0, 1, 0, 1];
        break;
      case 3:
        imgNum = [0, 1, 2, 1];
        break;
      case 4:
        imgNum = [0, 1, 2, 3];
        break;
    }
    return Container(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => openImage(context, imgNum[0]),
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Hero(
                            tag: timeline.images[imgNum[0]],
                            child: Image.file(
                              File(p.join(
                                  imageData, timeline.images[imgNum[0]])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (imageCount >= 4) ...[
                      const SizedBox(
                        height: 2,
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => openImage(context, imgNum[imgNum[2]]),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Hero(
                              tag: timeline.images[imgNum[2]],
                              child: Image.file(
                                File(p.join(
                                    imageData, timeline.images[imgNum[2]])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (imageCount >= 2) ...[
                const SizedBox(width: 2),
                Flexible(
                  child: Column(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () => openImage(context, imgNum[1]),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Hero(
                              tag: timeline.images[imgNum[1]],
                              child: Image.file(
                                File(p.join(
                                    imageData, timeline.images[imgNum[1]])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (imageCount >= 3) ...[
                        const SizedBox(
                          height: 2,
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () => openImage(context, imgNum[3]),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Hero(
                                tag: timeline.images[imgNum[3]],
                                child: Image.file(
                                  File(p.join(
                                      imageData, timeline.images[imgNum[3]])),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void openImage(BuildContext context, final int index) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _GalleryPhotoViewWrapper(
          imageData: imageData,
          imagePaths: timeline.images,
          initialIndex: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

// 画像を拡大表示するページ
class _GalleryPhotoViewWrapper extends StatefulWidget {
  _GalleryPhotoViewWrapper({
    this.initialIndex = 0,
    required this.imagePaths,
    required this.imageData,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<String> imagePaths; // 画像のパス
  final String imageData; // 画像の保存先のルートパス

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<_GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            GestureDetector(
              onVerticalDragStart: (details) {
                Navigator.of(context).pop();
              },
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.imagePaths.length,
                loadingBuilder: null,
                backgroundDecoration: null,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${currentIndex + 1}/${widget.imagePaths.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 0,
              child: IconButton(
                onPressed: (() => Navigator.of(context).pop()),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.imagePaths[index];
    return PhotoViewGalleryPageOptions(
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 2.0,
      imageProvider: FileImage(File(p.join(widget.imageData, item))),
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}

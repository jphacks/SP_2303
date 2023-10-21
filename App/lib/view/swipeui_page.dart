import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gohan_map/component/app_rating_bar.dart';

class SwipeUIPage extends StatefulWidget {
  const SwipeUIPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SwipeUIPage> createState() => SwipeUIPageState();
}

class SwipeUIPageState extends State<SwipeUIPage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "今の気分に合ってる？",
                style: TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "左右にスワイプして気になるお店を選びましょう",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: AppinioSwiper(
                  backgroundCardsCount: 3,
                  swipeOptions:
                      const AppinioSwipeOptions.symmetric(horizontal: true),
                  unlimitedUnswipe: true,
                  controller: controller,
                  unswipe: _unswipe,
                  onSwipe: _swipe,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20,
                    bottom: 40,
                  ),
                  onEnd: _onEnd,
                  cardsCount: candidates.length,
                  cardsBuilder: (BuildContext context, int index) {
                    return AnonymousPostCard(candidate: candidates[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    swipeLeftButton(controller),
                    swipeRightButton(controller),
                    unswipeButton(controller),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void reload() {}

  void _swipe(int index, AppinioSwiperDirection direction) {
    log("the card was swiped to the: " + direction.name);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    log("end reached!");
  }
}

class AnonymousPostCard extends StatelessWidget {
  final CandidateModel candidate;

  const AnonymousPostCard({
    Key? key,
    required this.candidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CupertinoColors.white,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: candidate.img!.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            //左寄せ用
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: AppRatingBar(
                        initialRating: 4,
                        onRatingUpdate: (rating) {},
                        itemSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CandidateModel {
  String? googlePlaceId;
  Image? img;
  double? star;

  CandidateModel({
    this.googlePlaceId,
    this.img,
    this.star,
  });
}

List<CandidateModel> candidates = [
  CandidateModel(
    googlePlaceId: "xxxxxxxx",
    img: Image.network(
      "https://cdn-ak.f.st-hatena.com/images/fotolife/M/Manpapa/20211119/20211119142229.jpg",
      fit: BoxFit.cover,
    ),
    star: 5,
  ),
  CandidateModel(
    googlePlaceId: "xxxxxxxx",
    img: Image.network(
      "https://plus.chunichi.co.jp/pic/236/p1/878_0_01.jpg",
      fit: BoxFit.cover,
    ),
    star: 4,
  ),
  CandidateModel(
    googlePlaceId: "xxxxxxxx",
    img: Image.network(
      "https://tblg.k-img.com/restaurant/images/Rvw/155995/640x640_rect_155995886.jpg",
      fit: BoxFit.cover,
    ),
    star: 4.5,
  ),
  CandidateModel(
    googlePlaceId: "xxxxxxxx",
    img: Image.network(
      "https://www.kajiken.biz/wp/wp-content/uploads/2017/06/sakae_shio-480x480.jpg",
      fit: BoxFit.cover,
    ),
    star: 4,
  ),
  CandidateModel(
    googlePlaceId: "xxxxxxxx",
    img: Image.network(
      "https://blogimg.goo.ne.jp/image/upload/f_auto,q_auto,t_image_sp_entry/v1/user_image/23/5f/a06d2be63d977115f3a78ce1e5ea2f92.jpg",
      fit: BoxFit.cover,
    ),
    star: 4.5,
  ),
];


class SwipeUIButton extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const SwipeUIButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: child,
    );
  }
}

//swipe card to the right side
Widget swipeRightButton(AppinioSwiperController controller) {
  return SwipeUIButton(
    onTap: () => controller.swipeRight(),
    child: Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.activeGreen,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.activeGreen.withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_rounded,
            color: CupertinoColors.white,
            size: 30,
          ),
          Text("気になる！",
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    ),
  );
}

//swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller) {
  return SwipeUIButton(
    onTap: () => controller.swipeLeft(),
    child: Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF3868),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3868).withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.close,
            color: CupertinoColors.white,
            size: 30,
          ),
          Text("気分じゃない",
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    ),
  );
}

//unswipe card
Widget unswipeButton(AppinioSwiperController controller) {
  return SwipeUIButton(
    onTap: () => controller.unswipe(),
    child: Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: const Icon(
        Icons.rotate_left_rounded,
        color: CupertinoColors.systemGrey2,
        size: 40,
      ),
    ),
  );
}
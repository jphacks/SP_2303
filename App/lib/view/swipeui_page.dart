import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_rating_bar.dart';
import 'package:gohan_map/utils/apis.dart';
import 'package:gohan_map/view/swipe_result_page.dart';

class SwipeUIPage extends StatefulWidget {
  const SwipeUIPage({
    Key? key,
    required this.results,
  }) : super(key: key);
  final List<SwipeUIAPIResult> results;

  @override
  State<SwipeUIPage> createState() => SwipeUIPageState();
}

class SwipeUIPageState extends State<SwipeUIPage> {
  final AppinioSwiperController controller = AppinioSwiperController();
  List<CandidateModel> goodCandidates = [];
  int nowIndex = 0;
  bool isSwipingRight = false;
  bool isSwipingLeft = false;
  List<CandidateModel> candidates = [];
  @override
  void initState() {
    for (var result in widget.results) {
      print(result.imageURL);
      //String img to Image
      candidates.add(CandidateModel(
        googlePlaceId: result.googleMapShopId,
        name: result.name,
        address: result.address,
        latitude: result.latitude,
        longitude: result.longitude,
        star: result.star,
        img: Image.network(
          result.imageURL,
          fit: BoxFit.cover,
        ),
      ));
    }

    super.initState();
  }

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
                child: Stack(
                  children: [
                    AppinioSwiper(
                      backgroundCardsCount: 3,
                      swipeOptions:
                          const AppinioSwipeOptions.symmetric(horizontal: true),
                      unlimitedUnswipe: true,
                      controller: controller,
                      onSwipe: _swipe,
                      onSwiping: (direction) {
                        if (direction == AppinioSwiperDirection.right) {
                          setState(() {
                            isSwipingRight = true;
                            isSwipingLeft = false;
                          });
                        } else if (direction == AppinioSwiperDirection.left) {
                          setState(() {
                            isSwipingRight = false;
                            isSwipingLeft = true;
                          });
                        } else {
                          setState(() {
                            isSwipingRight = false;
                            isSwipingLeft = false;
                          });
                        }
                      },
                      onSwipeCancelled: () {
                        setState(() {
                          isSwipingRight = false;
                          isSwipingLeft = false;
                        });
                      },
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
                    leftIcon(isSwipingLeft),
                    rightIcon(isSwipingRight),
                  ],
                ),
              ),
              swipeProgressBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    swipeLeftButton(controller),
                    swipeRightButton(controller),
                    swipeEndButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> leftIcon(bool isSwipingLeft) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: isSwipingLeft ? 1 : 0,
      ),
      builder: (context, value, _) => Positioned(
        left: 0,
        bottom: 0,
        top: 0,
        child: Center(
          child: Container(
            height: value * 60,
            width: value * 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3868),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3868).withOpacity(0.9 * value),
                  spreadRadius: -10,
                  blurRadius: 20,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: value,
              child: const Icon(
                Icons.thumb_down,
                color: AppColors.whiteColor,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> rightIcon(bool isSwipingRight) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: isSwipingRight ? 1 : 0,
      ),
      builder: (context, value, _) => Positioned(
        right: 0,
        bottom: 0,
        top: 0,
        child: Center(
          child: Container(
            height: value * 60,
            width: value * 60,
            decoration: BoxDecoration(
              color: CupertinoColors.activeGreen,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.activeGreen.withOpacity(0.9 * value),
                  spreadRadius: -10,
                  blurRadius: 20,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: value,
              child: const Icon(
                Icons.thumb_up,
                color: AppColors.whiteColor,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> swipeProgressBar() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: (nowIndex / candidates.length).toDouble(),
      ),
      builder: (context, value, _) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            color: AppColors.primaryColor,
            backgroundColor: AppColors.primaryColor.withOpacity(0.2),
            minHeight: 10,
          ),
        ),
      ),
    );
  }

  //スワイプされたときに呼ばれる
  void _swipe(int index, AppinioSwiperDirection direction) {
    setState(() {
      nowIndex = index;
      isSwipingLeft = false;
      isSwipingRight = false;
    });
    if (direction == AppinioSwiperDirection.right) {
      goodCandidates.add(candidates[index - 1]);
    }
    log("the card was swiped to the: ${direction.name}");
  }

  void _onEnd() {
    log("end reached!");
    if (goodCandidates.isEmpty) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return SwipeResultPage(
          candidates: goodCandidates,
        );
      }));
    }
  }

  Widget swipeEndButton() {
    return SwipeUIButton(
      onTap: () => _onEnd(),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.9),
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
              Icons.check,
              color: CupertinoColors.white,
              size: 30,
            ),
            Text("終わる！",
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
                  image: candidate.img.image,
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
                        initialRating: candidate.star,
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
  int? id;
  bool? isPicked;
  String googlePlaceId;
  String name;
  String address;
  double latitude;
  double longitude;
  Image img;
  double star;

  CandidateModel({
    this.id,
    this.isPicked,
    required this.googlePlaceId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.img,
    required this.star,
  });
}

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
            Icons.thumb_up,
            color: CupertinoColors.white,
            size: 30,
          ),
          SizedBox(
            width: 8,
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
            Icons.thumb_down,
            color: CupertinoColors.white,
            size: 30,
          ),
          SizedBox(
            width: 8,
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

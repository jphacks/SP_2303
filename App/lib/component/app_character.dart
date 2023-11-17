import 'package:flutter/Material.dart';
import 'dart:async';
import 'dart:math' as math;

enum AnimationKind { normal, walk, jump , all}

Map<AnimationKind, String> animationImagePath = {
  AnimationKind.normal: "images/characters/normal_close.png",
  AnimationKind.jump: "images/characters/jump.png",
  AnimationKind.walk: "images/characters/walk.png",
  AnimationKind.all: "images/characters/allmove.png",
};

class AppCharacter extends StatefulWidget {
  const AppCharacter({
    super.key,
  });

  @override
  State<AppCharacter> createState() => AppCharacterState();
}

class AppCharacterState extends State<AppCharacter> {
  AnimationKind curAnimation = AnimationKind.normal;
  int fps = 20;

  @override
  void initState() {
    super.initState();
    //animateNormal();
  }

  @override
  Widget build(BuildContext context) {
    //var imagePath = animationImagePath[curAnimation] ?? "";
    //全ての動作を1つのapngにまとめた
    var imagePath = animationImagePath[AnimationKind.all] ?? "";
    return Image.asset(
      imagePath,
      height: 300,
    );
  }

  void animateNormal() {
    int totalFrameRate = 100;
    int timeMi = (totalFrameRate / fps * 1000).floor();
    setState(() {
      curAnimation = AnimationKind.normal;
    });
    var randomNum = math.Random().nextDouble();
    if (randomNum >= 0.5) {
      Timer(Duration(milliseconds: timeMi), animateWalk);
    } else {
      Timer(Duration(milliseconds: timeMi), animateJump);
    }
  }

  void animateJump() {
    int totalFrameRate = 130;
    int timeMi = (totalFrameRate / fps * 1000).floor();
    setState(() {
      curAnimation = AnimationKind.jump;
    });
    Timer(Duration(milliseconds: timeMi), animateNormal);
  }

  void animateWalk() {
    int totalFrameRate = 100;
    int timeMi = (totalFrameRate / fps * 1000).floor();
    setState(() {
      curAnimation = AnimationKind.walk;
    });
    Timer(Duration(milliseconds: timeMi), animateNormal);
  }
}

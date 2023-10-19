import 'package:flutter/material.dart';

import 'package:flutter_overboard/flutter_overboard.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);
  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: OverBoard(
        allowScroll: true,
        pages: pages,
        showBullets: true,
        inactiveBulletColor: Colors.grey,
        // backgroundProvider: NetworkImage('https://picsum.photos/720/1280'),
        skipCallback: () {
          Navigator.of(context).pop();
        },
        finishCallback: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  final pages = [
    PageModel(
      color: const Color(0xFF2196F3),
        imageAssetPath: 'images/dummyMap.png',
        title: 'gohan_mapへようこそ',
        body: 'gohan_mapは\n飲食店を登録して\n食べたものを記録するアプリです',
        doAnimateImage: true),
    PageModel(
      color: const Color(0xFF31A6FF),
        imageAssetPath: 'images/dummyMap.png',
        title: '飲食店の登録',
        body: '地図を長押しすることで\nその場所に飲食店を登録できます\n検索して登録することもできます',
        doAnimateImage: true),
    PageModel(
      color: const Color(0xFF2196F3),
        imageAssetPath: 'images/dummyMap.png',
        title: '食事の記録',
        body: '飲食店を登録すると\nその場所で食べたものを記録できます\n記録した食事は、飲食店のピンをタップすると確認できます',
        doAnimateImage: true),
    PageModel(
      color: const Color(0xFF31A6FF),
        imageAssetPath: 'images/dummyMap.png',
        title: 'はじめましょう',
        body: '日々の外食を記録して\n自分だけの地図を作りましょう\n',
        doAnimateImage: true),
  ];
}
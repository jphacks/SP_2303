import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gohan_map/bottom_navigation.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/tab_navigator.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:gohan_map/utils/safearea_utils.dart';
import 'package:gohan_map/view/all_post_page.dart';
import 'package:gohan_map/view/character_page.dart';
import 'package:gohan_map/view/map_page.dart';
import 'package:gohan_map/view/swipeui_page.dart';
import 'package:google_fonts/google_fonts.dart';

/// アプリが起動したときに呼ばれる
void main() {
  logger.i("start application!");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
  ));
  // スプラッシュ画面をロードが終わるまで表示する
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

///アプリケーションの最上位のウィジェット
///ウィジェットとは、画面に表示される要素のこと。
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //セーフエリア外の高さを保存しておく
    SafeAreaUtil.unSafeAreaBottomHeight = MediaQuery.of(context).padding.bottom;
    SafeAreaUtil.unSafeAreaTopHeight = MediaQuery.of(context).padding.top;
    return MaterialApp(
      title: 'Gohan Map',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: MainPage(),
      ),
      theme: ThemeData(
        fontFamily: (Platform.isAndroid) ? "SanFrancisco" : null,
        fontFamilyFallback: (Platform.isAndroid) ? ["HiraginoSans"] : null,
      ),
    );
  }
}

enum TabItem {
  map,
  swipe,
  character,
}

//タブバー(BottomNavigationBar)を含んだ全体の画面
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab = TabItem.map;
  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.map: GlobalKey<NavigatorState>(),
    TabItem.swipe: GlobalKey<NavigatorState>(),
    TabItem.character: GlobalKey<NavigatorState>(),
  };

  //globalKeyは、ウィジェットの状態を保存するためのもの
  final Map<TabItem, GlobalKey<State>> _globalKeys = {
    TabItem.map: GlobalKey<State>(),
    TabItem.swipe: GlobalKey<State>(),
    TabItem.character: GlobalKey<State>(),
  };

  final allpostKey = GlobalKey<AllPostPageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildTabItem(
            TabItem.map,
            '/map',
          ),
          _buildTabItem(
            TabItem.swipe,
            '/allpost',
          ),
          _buildTabItem(
            TabItem.character,
            '/character',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentTab: _currentTab,
        onSelect: onSelect,
      ),
    );
  }

  Widget _buildTabItem(
    TabItem tabItem,
    String root,
  ) {
    return Offstage(
      //Offstageは、子要素を非表示にするウィジェット
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigationKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        routerName: root,
        globalKey: _globalKeys[tabItem]!,
      ),
    );
  }

  //タブが選択されたときに呼ばれる。tabItemは選択されたタブ
  void onSelect(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
    //選択されたタブをリロードする
    if (tabItem == TabItem.swipe) {
      SwipeUIPageState? allpostPageState =
          _globalKeys[tabItem]!.currentState as SwipeUIPageState?;
      allpostPageState?.reload();
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else if (tabItem == TabItem.map) {
      MapPageState? mapPageState =
          _globalKeys[tabItem]!.currentState as MapPageState?;
      mapPageState?.reload();
    } else if (tabItem == TabItem.character) {
      CharacterPageState? characterPageState =
          _globalKeys[tabItem]!.currentState as CharacterPageState?;
      characterPageState?.reload();
    }
    //タブの最初の画面に戻る
    //_navigatorKeys[TabItem.swipe]?.currentState?.popUntil((route) => route.isFirst);
    _navigatorKeys[TabItem.map]
        ?.currentState
        ?.popUntil((route) => route.isFirst);
    _navigatorKeys[TabItem.character]
        ?.currentState
        ?.popUntil((route) => route.isFirst);
  }
}

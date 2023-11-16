import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gohan_map/bottom_navigation.dart';

import 'package:gohan_map/firebase_options.dart';
import 'package:gohan_map/tab_navigator.dart';
import 'package:gohan_map/utils/auth_state.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:gohan_map/utils/safearea_utils.dart';
import 'package:gohan_map/view/all_post_page.dart';
import 'package:gohan_map/view/character_page.dart';
import 'package:gohan_map/view/login_page.dart';
import 'package:gohan_map/view/map_page.dart';
import 'package:gohan_map/view/swipeui_pre_page.dart';

/// アプリが起動したときに呼ばれる
void main() async {
  logger.i("start application!");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
  ));

  // スプラッシュ画面をロードが終わるまで表示する
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

///アプリケーションの最上位のウィジェット
///ウィジェットとは、画面に表示される要素のこと。
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //セーフエリア外の高さを保存しておく
    SafeAreaUtil.unSafeAreaBottomHeight = MediaQuery.of(context).padding.bottom;
    SafeAreaUtil.unSafeAreaTopHeight = MediaQuery.of(context).padding.top;
    //ログイン済みか
    final isSignedIn = ref.watch(isSignedInProvider);
    return MaterialApp(
      title: 'Umap',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: (isSignedIn) ? const MainPage() : const LoginPage(),
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
  setting,
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
    TabItem.setting: GlobalKey<NavigatorState>(),
  };

  //globalKeyは、ウィジェットの状態を保存するためのもの
  final Map<TabItem, GlobalKey<State>> _globalKeys = {
    TabItem.map: GlobalKey<State>(),
    TabItem.swipe: GlobalKey<State>(),
    TabItem.character: GlobalKey<State>(),
    TabItem.setting: GlobalKey<State>(),
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
          _buildTabItem(
            TabItem.setting,
            '/setting',
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
    //選択されたタブをリロードする
    if (tabItem == TabItem.swipe) {
      SwipeUIPrePageState? allpostPageState =
          _globalKeys[tabItem]!.currentState as SwipeUIPrePageState?;
      allpostPageState?.reload();
      if (_currentTab == tabItem) {
        _navigatorKeys[tabItem]
            ?.currentState
            ?.popUntil((route) => route.isFirst);
      }
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
    setState(() {
      _currentTab = tabItem;
    });
  }
}

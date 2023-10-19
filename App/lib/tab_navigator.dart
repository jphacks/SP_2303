import 'package:flutter/Material.dart';
import 'package:gohan_map/main.dart';
import 'package:gohan_map/view/character_page.dart';
import 'package:gohan_map/view/map_page.dart';
import 'package:gohan_map/view/swipeui_page.dart';

//現在のタブによって、Navigatorを切り替えるためのクラス
//これを使うことで、タブの内部で画面遷移ができる
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.tabItem,
    required this.routerName,
    required this.navigationKey,
    required this.globalKey,
  }) : super(key: key);

  final TabItem tabItem;
  final String routerName;
  final GlobalKey<NavigatorState> navigationKey;
  final GlobalKey<State> globalKey;

  Map<String, Widget Function(BuildContext)> _routerBuilder(BuildContext context) => {
    '/map': (context) => MapPage(key: globalKey,),
    '/allpost': (context) => SwipeUIPage(key: globalKey,),
    '/character': (context) => CharacterPage(key : globalKey,),
  };

  @override
  Widget build(BuildContext context) {
    final routerBuilder = _routerBuilder(context);

    return Navigator(
      key: navigationKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return routerBuilder[routerName]!(context);
          },
        );
      },
    );
  }
}

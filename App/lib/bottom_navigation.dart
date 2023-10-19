import 'package:flutter/material.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/icon/app_icon_icons.dart';
import 'package:gohan_map/main.dart';

const tabTitle = <TabItem, String>{
  TabItem.map: 'マップ',
  TabItem.swipe: 'スワイプ',
  TabItem.character: 'キャラクター',
};
const tabIcon = <TabItem, IconData>{
  TabItem.map: AppIcons.map_marked_alt,
  TabItem.swipe: Icons.thumbs_up_down,
  TabItem.character: AppIcons.paw,
};

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelect,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 10,
        ),
      ]),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          bottomItem(
            context,
            tabItem: TabItem.map,
          ),
          bottomItem(
            context,
            tabItem: TabItem.swipe,
          ),
          bottomItem(
            context,
            tabItem: TabItem.character,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        onTap: (index) {
          onSelect(TabItem.values[index]);
        },
      ),
    );
  }

  BottomNavigationBarItem bottomItem(
    BuildContext context, {
    required TabItem tabItem,
  }) {
    final color = currentTab == tabItem ? AppColors.tabBarColor : Colors.black26;
    return BottomNavigationBarItem(
      icon: Column( 
        children: [
          const SizedBox(
          height: 8,
          ),
          Icon(
            tabIcon[tabItem],
            color: color,
          ),
          Text(tabTitle[tabItem] ?? '',
              style: TextStyle(
                color: color,
                fontSize: 12,
              )),
        ],
      ),
      label: '',
    );
  }
}

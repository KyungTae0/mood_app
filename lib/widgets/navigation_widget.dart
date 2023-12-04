import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  NavigationWidget({
    super.key,
    required this.onSelectedIndex,
    required this.selectedIndex,
  });

  final void Function(int) onSelectedIndex;
  int selectedIndex;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      onTap: (index) {
        widget.onSelectedIndex(index);
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,

      // 아이콘 요소들
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home),
          icon: Icon(
            Icons.home_outlined,
            color: Colors.black38,
          ),
          // label 없으면 에러남..
          label: '홈',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.create),
          icon: Icon(
            Icons.create_outlined,
            color: Colors.black38,
          ),
          // label 없으면 에러남..
          label: '글쓰기',
        ),
      ],
    );
  }
}

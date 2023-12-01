import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({
    super.key,
    required this.onSelectedIndex,
    required this.selectedIndex,
  });

  final void Function(int) onSelectedIndex;
  final int selectedIndex;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // 라벨 숨기기
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      height: 60,
      // 얘로 현재 페이지 변경함
      onDestinationSelected: widget.onSelectedIndex,
      // 페이지 인덱스
      selectedIndex: widget.selectedIndex,
      elevation: 0,
      backgroundColor: Colors.white,
      indicatorColor: Colors.white,
      // 아이콘 요소들
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(
            Icons.home_outlined,
            color: Colors.black38,
          ),
          // label 없으면 에러남..
          label: '홈',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.create),
          icon: Icon(
            Icons.create_outlined,
            color: Colors.black38,
          ),
          label: '글쓰기',
        ),
      ],
    );
  }
}

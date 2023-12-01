import 'package:flutter/material.dart';
import 'package:sam_mood_app/screens/mood/home_screen.dart';
import 'package:sam_mood_app/screens/mood/post/post_screen.dart';
import 'package:sam_mood_app/widgets/navigation_widget.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 네비게이션 인덱스 변경 이벤트
  void onSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      // 원래 BottomNavigationBar로 했다가 3개 넘으면 아이콘 누를때 자꾸 움직이길래 얘로 바꿈
      bottomNavigationBar: NavigationWidget(
          onSelectedIndex: onSelectedIndex, selectedIndex: selectedIndex),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: [
          const HomeScreen(), // 홈
          const PostScreen(), // 검색
        ][selectedIndex],
      ),
    );
  }
}

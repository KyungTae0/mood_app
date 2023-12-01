import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sam_mood_app/screens/mood/navigation_screen.dart';
import 'package:sam_mood_app/screens/user/sign_in_screen.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // authStateChanges 를 통해 실시간으로 로그인이 되었는지 상태 구독
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print("스냅샷검사해라");
          print(!snapshot.hasData);
          if (!snapshot.hasData) {
            return const SignIn();
          } else {
            // FirebaseAuth.instance.signOut();
            return const NavigationScreen();
          }
        });
  }
}

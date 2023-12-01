import 'package:flutter/material.dart';
import 'package:sam_mood_app/root.dart';
import 'package:sam_mood_app/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      home: const Root(),
    );

    // ===========================
    // router 연결
    // 기본적으로 / 로 설정해둔 screen으로 먼저 이동함
    // ===========================
    // return MaterialApp.router(
    //   routerConfig: _router,
    //   theme: ThemeData(fontFamily: "Pretendard"),
    // );
  }
}

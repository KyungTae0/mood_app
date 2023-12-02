import 'package:flutter/material.dart';
import 'package:sam_mood_app/providers/user_auth_provider.dart';
import 'package:sam_mood_app/root.dart';
import 'package:sam_mood_app/screens/mood/navigation/navigation_screen.dart';
import 'package:sam_mood_app/screens/mood/post/post_screen.dart';
import 'package:sam_mood_app/screens/user/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // 여러개의 Provider 를 사용 할 때 (임시)
    MultiProvider(
      providers: [
        // 아래 Provider의 변화에 대한 구독
        ChangeNotifierProvider(
          create: (context) => UserAuthProvider(),
        )
      ],
      child: const App(),
    ),
  );

  // runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Syongsyong"),
      // home: const SignIn(),
      // home: MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider<UserAuthProvider>(create: (_) => UserAuthProvider())
      //   ],
      //   child: const SignIn(),
      // )

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

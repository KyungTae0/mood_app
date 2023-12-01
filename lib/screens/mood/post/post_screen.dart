import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sam_mood_app/models/mood_model.dart';
import 'package:sam_mood_app/screens/mood/post/select_emotion_screen.dart';
import 'package:sam_mood_app/screens/mood/post/write_content_screen.dart';
import 'package:sam_mood_app/widgets/mood_container_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    // 다른 페이지에서 왔다갔다 하면 초기화
    setState(() {
      pageIndex = 0;
    });
  }

  // post 페이지 인덱스
  int pageIndex = 0;
  // 글쓰기 저장 데이터
  MoodModel moodData = MoodModel(
      emoji: "",
      createdAt: DateTime.now(),
      content: "",
      uid: "",
      image: "",
      imageRef: "");

  /// 파이어베이스 연결 세팅
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void setPageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void setEmoji(String emoji) {
    setState(() {
      moodData.emoji = emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MoodContainer(
      appBarTitle: "글쓰기",
      body: [
        SelectEmotionScreen(
          firestore: firestore,
          setPageIndex: setPageIndex,
          setEmoji: setEmoji,
        ),
        WriteContentScreen(moodData: moodData)
      ][pageIndex],
    );
  }
}

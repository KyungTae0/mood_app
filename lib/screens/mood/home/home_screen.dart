import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sam_mood_app/models/mood_model.dart';
import 'package:sam_mood_app/widgets/dashed_divider_widget.dart';
import 'package:sam_mood_app/widgets/mood_card_widget.dart';
import 'package:sam_mood_app/widgets/mood_container_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 게시글 삭제
  void deleteDoc(String id, String imageRef) async {
    try {
      // mood 컬렉션의 id 에 해당하는 문서 삭제
      await _firestore.collection("mood").doc(id).delete();

      // 이미지 저장 경로가 존재 할 시 이미지 삭제
      if (imageRef.isNotEmpty) {
        // 이미지 삭제
        await FirebaseStorage.instance.ref(imageRef).delete();
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('성공'),
            content: const Text('삭제에 성공했습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('에러'),
            content: const Text('삭제에 실패했습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MoodContainer(
      appBarTitle: "mood",
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        /// StreamBuilder를 통해 조회해온 collection 의 데이터 구독
        child: StreamBuilder(
          stream: _firestore
              .collection('mood')
              .where(
                "uid",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                // isEqualTo: context.select((UserAuthProvider a) => a.getUser()?.uid),
              )
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // 아직 조회중일 경우 로딩 창 생성
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                //로딩바 구현 부분
                child: SpinKitFadingCube(
                  // FadingCube 모양 사용
                  color: Colors.purple, // 색상 설정
                  size: 50.0, // 크기 설정
                  duration: Duration(seconds: 2), //속도 설정
                ),
              );
            }
            // 조회해온 docs의 List
            final docs = snapshot.data?.docs;
            if (docs == null) {
              return const Center(
                //로딩바 구현 부분
                child: SpinKitFadingCube(
                  // FadingCube 모양 사용
                  color: Colors.purple, // 색상 설정
                  size: 50.0, // 크기 설정
                  duration: Duration(seconds: 2), //속도 설정
                ),
              );
            }
            // 데이터가 많고 얼만큼의 데이터가 있을지 모르기에 ListView.separated 사용
            return ListView.separated(
              // overflow 방지
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                // 점선 디바이더
                child: DashedDivider(
                  thickness: 2,
                  color: Color.fromARGB(170, 170, 170, 170),
                ),
              ),
              itemBuilder: (context, index) {
                // 문서 데이터
                final doc = docs[index];
                // 문서 데이터를 Map<string, dynamic> -> MoodModel 형태로 캐스팅
                // mood.emoji, mood.content 와 같이 사용 할 수 있음
                final mood = MoodModel.fromJson(doc.data());
                // mood 데이터 뿌리기
                return MoodCardWidget(
                  docId: doc.id,
                  mood: mood,
                  deleteDoc: deleteDoc,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

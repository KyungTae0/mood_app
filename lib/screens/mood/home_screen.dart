import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sam_mood_app/widgets/dashed_divider_widget.dart';
import 'package:sam_mood_app/widgets/mood_container_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String fommatingDate(String date) {
    // 예시로 주어진 날짜 문자열
    String dateString = '2023-12-02T01:45:17.873907';

    // 문자열을 DateTime으로 파싱
    DateTime dateTime = DateTime.parse(dateString);

    // DateTime을 원하는 형식으로 포맷팅
    String formattedDate = DateFormat('MM월 dd일').format(dateTime);

    // 결과 출력
    return formattedDate; // 출력: 2023년 12월 02일 오전 01시 45분
  }

  String formattedDay(String date) {
    // 예시로 주어진 날짜 문자열
    String dateString = '2023-12-02T01:45:17.873907';

    // 문자열을 DateTime으로 파싱
    DateTime dateTime = DateTime.parse(dateString);

    // DateTime을 요일 형식으로 포맷팅
    String formattedDay = DateFormat('EEEE').format(dateTime);

    // 결과 출력
    return formattedDay; // 출력: 금요일
  }

  void deleteDoc(String id, String imageRef) async {
    try {
      await _firestore.collection("mood").doc(id).delete();

      if (imageRef.isNotEmpty) {
        // 이미지 저장
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
        child: StreamBuilder(
          stream: _firestore
              .collection('mood')
              .where(
                "uid",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                // isEqualTo: context.select((UserAuthProvider a) => a.getUser()?.uid),
              )
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
            final docs = snapshot.data!.docs;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: DashedDivider(
                  thickness: 2,
                  color: Color.fromARGB(170, 170, 170, 170),
                ),
              ),
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Text(
                                doc['emoji'],
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              title: Text(
                                fommatingDate(
                                  doc['createdAt'],
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(formattedDay(doc['createdAt'])),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteDoc(doc.id, doc['imageRef']);
                                },
                                icon: const Icon(
                                  Icons.delete_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 21,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (doc['image'] != null &&
                                      doc['image'] != "")
                                    Column(
                                      children: [
                                        Image.network(
                                          doc['image'],
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 200,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  Text(
                                    doc['content'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

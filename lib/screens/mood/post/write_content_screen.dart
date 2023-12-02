import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam_mood_app/models/mood_model.dart';
import 'package:sam_mood_app/providers/user_auth_provider.dart';
import 'package:sam_mood_app/screens/mood/navigation/navigation_screen.dart';
import 'package:sam_mood_app/widgets/image_container_widget.dart';

class WriteContentScreen extends StatefulWidget {
  const WriteContentScreen({
    super.key,
    required this.moodData,
  });

  final MoodModel moodData;

  @override
  State<WriteContentScreen> createState() => _WriteContentScreenState();
}

class _WriteContentScreenState extends State<WriteContentScreen> {
  // ========================================================
  // form Data
  // ========================================================
  // 글 내용
  final TextEditingController content = TextEditingController();
  // 폼 키
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 이미지 파일 저장 변수
  File? _file;

  // ========================================================
  // FireBase
  // ========================================================
  // 파이어스토어 객체 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // 유저 Provider
  late UserAuthProvider userAuthProvider;

  // 버튼 활성화 여부
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    content.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    super.dispose();
    content.dispose();
  }

  /// 유효성검사
  void checkFormValidity() {
    final isFormValid = content.text.isNotEmpty;

    if (isFormValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isFormValid;
      });
    }
  }

  /// 이미지 변경 이벤트
  void setImage(File? imageFile) {
    setState(() {
      _file = imageFile;
    });
  }

  /// 저장하기 이벤트
  Future<bool> onSubmit(String uid) async {
    try {
      if (_formKey.currentState != null) {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          // user id 저장
          widget.moodData.uid = uid;
          // 이미지 기본 값 없음 세팅
          widget.moodData.image = "";
          widget.moodData.imageRef = "";

          if (_file != null) {
            final imageInfo = await storageUpload(uid);
            // 이미지 존재할 시 이미지 저장
            widget.moodData.image = imageInfo!["image"]!;
            widget.moodData.imageRef = imageInfo["path"]!;
          }
          // mood 저장
          await _firestore
              .collection("mood")
              .doc()
              .set(widget.moodData.toJson());

          return Future<bool>.value(true);
        }
      }
    } catch (error) {
      print(error);
      return Future<bool>.value(false);
    }
    return Future<bool>.value(false);
  }

  /// firebase storage에 이미지 파일 업로드 하여 패스 반환 받음
  Future<Map<String, String>?> storageUpload(String uid) async {
    if (_file != null) {
      final String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

      // 스토리지 주소 생성
      String imageRef = "mood/${uid}_$dateTime";
      // 이미지 저장
      await FirebaseStorage.instance.ref(imageRef).putFile(
          _file!,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      // 저장한 이미지 다운로드 경로 취득
      final String urlString =
          await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
      return {
        "image": urlString,
        "path": imageRef,
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "오늘 있었던 일",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    onChanged: (context) {},
                    controller: content,
                    maxLines: null, //or null

                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "내용을 적어주세요";
                      }
                      return null;
                    },
                    onSaved: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          widget.moodData.content = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "사진 추가하기",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // 이미지 불러오기 및 선택 노출 영역
                ImageContainer(setImage: setImage),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () async {
                bool result = await onSubmit(userAuthProvider.getUser()!.uid);
                if (result) {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('저장 성공!'),
                      content: const Text("글이 성공적으로 저장 되었습니다."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const NavigationScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('확인'),
                        )
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isButtonEnabled ? Colors.black : Colors.black26,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '저장하기',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          )
          // 이미지버튼이랑 선택한 이미지 보여주는 컨테이너
        ],
      ),
    );
  }
}

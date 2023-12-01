import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sam_mood_app/providers/user_auth_provider.dart';
import 'package:sam_mood_app/screens/user/sign_in_screen.dart';

class MoodContainer extends StatefulWidget {
  const MoodContainer({
    super.key,
    required this.body,
    required this.appBarTitle,
  });

  final Widget body;
  final String appBarTitle;

  @override
  State<MoodContainer> createState() => _MoodContainerState();
}

class _MoodContainerState extends State<MoodContainer> {
  UserAuthProvider userAuthProvider = UserAuthProvider();
  File? _file;

  @override
  Widget build(BuildContext context) {
    //이미지를 담을 변수 선언
    /// firebase storage에 이미지 파일 업로드 하여 패스 반환 받음
    Future<Map<String, String>?> updateProfilePhoto() async {
      if (_file != null) {
        final String dateTime =
            DateTime.now().millisecondsSinceEpoch.toString();

        // 스토리지 주소 생성
        String imageRef =
            "mood/${FirebaseAuth.instance.currentUser!.uid}_$dateTime";
        // 이미지 저장
        await FirebaseStorage.instance.ref(imageRef).putFile(
            _file!,
            SettableMetadata(
              contentType: "image/jpeg",
            ));
        // 저장한 이미지 다운로드 경로 취득
        final String urlString =
            await FirebaseStorage.instance.ref(imageRef).getDownloadURL();

        await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlString);
      }

      return null;
    }

    //ImagePicker 초기화
    final ImagePicker picker = ImagePicker();

    Future<bool> isPermission() async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
      if (statuses[Permission.camera] == PermissionStatus.denied) {
        return false;
      }
      if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
        openAppSettings();

        return false;
      }

      return true;
    }

    Future getImage(ImageSource imageSource) async {
      final grant = await isPermission();
      if (!grant) {
        return;
      }

      //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(
          () {
            _file = File(
              pickedFile.path,
            ); //가져온 이미지를 _image에 저장
          },
        );
        await updateProfilePhoto();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(widget.appBarTitle),
        toolbarHeight: 30,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () => print("asdf"),
        // ),
      ),
      // ================================
      // 사이드 메뉴바
      // ================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(FirebaseAuth.instance.currentUser != null &&
                      FirebaseAuth.instance.currentUser!.displayName != null
                  ? FirebaseAuth.instance.currentUser!.displayName.toString()
                  : ""),
              accountEmail: Text(FirebaseAuth.instance.currentUser != null &&
                      FirebaseAuth.instance.currentUser!.email != null
                  ? FirebaseAuth.instance.currentUser!.email.toString()
                  : ""),

              // otherAccountsPictures: const [
              //   // currentAccountPicture와 같은 형태지만 복수로 지정 가능
              //   CircleAvatar(
              //     backgroundColor: Colors.white,
              //     // backgroundImage: AssetImage('assets/images/2.gif'),
              //   ),
              // ],
              onDetailsPressed: () => {
                // 더보기 화살표를 구현
                print("clicked")
              },
              // 유저 정보 부분 css
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ), // 화면의 첫 부분
              title: const Text("Home"),
              onTap: () => {print("home!!")},
              trailing: const Icon(Icons.add), // 화면의 끝 부분
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ), // 화면의 첫 부분
              title: const Text("Setting"),
              onTap: () => {print("Setting!!")},
              trailing: const Icon(Icons.add), // 화면의 끝 부분
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline_rounded,
                color: Colors.grey[850],
              ), // 화면의 첫 부분
              title: const Text("고객센터"),
              onTap: () => {print("고객센터")},
              trailing: const Icon(Icons.add), // 화면의 끝 부분
            ),
            ListTile(
              leading: Icon(
                Icons.help_outline_rounded,
                color: Colors.grey[850],
              ), // 화면의 첫 부분
              title: const Text("로그아웃"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그아웃'),
                      content: const Text('정말로 로그아웃 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            userAuthProvider.signOut();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const SignIn(),
                              ),
                              (route) => false,
                            );
                            // Navigator.of(context).pop();
                          },
                          child: const Text('확인'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                      ],
                    );
                  },
                );
              },
              trailing: const Icon(Icons.logout_outlined), // 화면의 끝 부분
            ),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}

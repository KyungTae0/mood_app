import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sam_mood_app/screens/mood/navigation/navigation_screen.dart';
import 'package:sam_mood_app/screens/user/sign_up_screen.dart';
import 'package:sam_mood_app/widgets/text_field_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    password.addListener(checkFormValidity);
  }

  void checkFormValidity() {
    final isFormValid = password.text.isNotEmpty && email.text.isNotEmpty;

    if (isFormValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isFormValid;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    password.dispose();
    email.dispose();
    super.dispose();
  }

  void onSubmit(context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email.value.text.trim(),
              password: password.value.text.trim());

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const NavigationScreen(),
            ),
            (route) => false,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == "invalid-email") {
            showFailedDialog("이메일 형식이 잘 못 되었습니다.");
          } else if (e.code == "invalid-credential") {
            showFailedDialog("계정 정보가 잘 못 되었습니다.");
          }
          print(e);
        } catch (e) {
          print("unknown catch error - $e");
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void showFailedDialog(text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('로그인 실패'),
              content: Text(text.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                  },
                  child: const Text('확인'),
                )
              ],
            ));
  }

  void showSignInDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('환영합니다 !'),
              content: const Text('로그인을 완료했습니다 ! 확인 버튼을 클릭하면 로그인 화면으로 이동합니다.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('확인'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("로그인"),
      ),
      body: _isLoading
          ? const Center(
              //로딩바 구현 부분
              child: SpinKitFadingCube(
                // FadingCube 모양 사용
                color: Colors.purple, // 색상 설정
                size: 50.0, // 크기 설정
                duration: Duration(seconds: 2), //속도 설정
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFieldWidget(
                                    hintText: "이메일",
                                    textFieldType: TextFieldType.email,
                                    textEditingController: email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "이메일을 입력해주세요";
                                      }
                                      return null;
                                    },
                                    onSaved: (String? newValue) {},
                                  ),
                                  TextFieldWidget(
                                    hintText: "비밀번호",
                                    textFieldType: TextFieldType.password,
                                    textEditingController: password,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "비밀번호를 입력해 주세요";
                                      }
                                      return null;
                                    },
                                    onSaved: (String? newValue) {
                                      if (newValue != null) {}
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "아직 회원이 아니신가요?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              TextButton(
                                  onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp(),
                                            fullscreenDialog: false,
                                          ),
                                        ),
                                      },
                                  child: Text(
                                    "회원가입",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue[500],
                                    ),
                                  ))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () => onSubmit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isButtonEnabled
                                    ? Colors.purple
                                    : Colors.black26,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('로그인'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

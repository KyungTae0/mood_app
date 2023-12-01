import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sam_mood_app/screens/user/sign_in_screen.dart';
import 'package:sam_mood_app/widgets/text_field_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController displayName = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    password.addListener(checkFormValidity);
    displayName.addListener(checkFormValidity);
    email.addListener(checkFormValidity);
  }

  void checkFormValidity() {
    final isFormValid = password.text.isNotEmpty &&
        email.text.isNotEmpty &&
        displayName.text.isNotEmpty;

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
    displayName.dispose();
  }

  void onSubmit(context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true; //애니메이션 효과를 위한 변수
        });
        try {
          final result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.value.text.trim(),
                  password: password.value.text.trim());
          User user = result.user!;

          // 회원가입할때는 이름 못넣어서 가입 후 이름 업데이트
          await user.updateDisplayName(displayName.value.text.trim());
          showSignUpDialog();

          print(result);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-email') {
            showFailedDialog('올바른 이메일 형식이 아닙니다.');
          } else if (e.code == 'weak-password') {
            showFailedDialog('비밀번호가 취약합니다.');
          } else if (e.code == 'email-already-in-use') {
            showFailedDialog('이미 존재하는 이메일입니다');
          }
        } catch (e) {
          print("내가 모르는 에러가 있다고!?@! $e");
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
        title: const Text('회원가입 실패'),
        content: Text(text.toString()),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: const Text('확인'))
        ],
      ),
    );
  }

  void showSignUpDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('환영합니다 !'),
              content: const Text('회원가입을 완료했습니다 ! 확인 버튼을 클릭하면 로그인 화면으로 이동합니다.'),
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const SignIn(),
                        ),
                        (route) => false,
                      );
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
        title: const Text("회원가입"),
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
                                    hintText: "이름",
                                    textFieldType: TextFieldType.text,
                                    textEditingController: displayName,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "이름을 입력해주세요";
                                      }
                                      return null;
                                    },
                                    onSaved: (String? newValue) {},
                                  ),
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
                              child: const Text('회원가입'),
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserAuthProvider with ChangeNotifier {
  /// 유저 인스턴스 초기화
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 유저 정보
  User? _user;

  /// 생성자에서 유저 정보 초기화 하여  변화가 발생할 시 새로운 유저정보를 가져옴
  UserAuthProvider() {
    _prepareUser();
  }

  /// 유저 정보 초기화
  void _prepareUser() {
    _user = _auth.currentUser;
  }

  /// 유저 정보 반환
  User? getUser() {
    return _user;
  }

  /// 커스텀 제공업체 로그인
  void signInAnonymously() async {
    final authResult = await _auth.signInAnonymously();
    setUser(authResult.user);
  }

  /// 유저 정보 변경
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  /// 로그아웃
  void signOut() async {
    await _auth.signOut();
    setUser(null);
  }

  /// 유저 정보 삭제
  void withdrawalAccount() async {
    await getUser()!.delete();
    setUser(null);
  }
}

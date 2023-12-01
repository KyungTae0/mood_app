import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  UserAuthProvider() {
    _prepareUser();
  }

  User? getUser() {
    return _user;
  }

  void _prepareUser() {
    _user = _auth.currentUser;
  }

  void signInAnonymously() async {
    final authResult = await _auth.signInAnonymously();
    setUser(authResult.user);
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();
    setUser(null);
  }

  void withdrawalAccount() async {
    await getUser()!.delete();
    setUser(null);
  }
}

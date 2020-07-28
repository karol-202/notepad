import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:notepad/model/user.dart';
import 'package:notepad/repository/auth/auth_exception.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  static const _TIMEOUT = Duration(seconds: 3);

  final _auth = FirebaseAuth.instance;

  @override
  Stream<User> getAuthState() => _auth.onAuthStateChanged.map((firebaseUser) => firebaseUser?.toUser());

  @override
  Future<void> register(String email, String password) => catchAuthExceptions(() async {
        await _auth.createUserWithEmailAndPassword(email: email, password: password).timeout(_TIMEOUT);
      });

  @override
  Future<void> login(String email, String password) => catchAuthExceptions(() async {
        await _auth.signInWithEmailAndPassword(email: email, password: password).timeout(_TIMEOUT);
      });

  @override
  Future<void> logout() async => await _auth.signOut();
}

extension on FirebaseUser {
  User toUser() => User(
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
}

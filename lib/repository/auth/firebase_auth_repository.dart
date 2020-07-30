import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notepad/model/user.dart';
import 'package:notepad/repository/auth/auth_exception.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  static const _TIMEOUT = Duration(seconds: 5);

  final _auth = FirebaseAuth.instance;
  final _googleSingIn = GoogleSignIn();

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
  Future<void> loginWithGoogle() => catchAuthExceptions(() async {
        final googleAccount = await _googleSingIn.signIn();
        final googleAuth = await googleAccount.authentication;
        final credentials = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await _auth.signInWithCredential(credentials);
      });

  @override
  Future<void> logout() async => await _auth.signOut();
}

extension on FirebaseUser {
  User toUser() => User(
        id: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
}

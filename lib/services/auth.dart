
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/member.dart';

class AuthService {
  final authInstance = FirebaseAuth.instance;

  //Connexion
  Future<MemberModel> signInWithEmailAndPassword(String mail, String pwd) async {
    late MemberModel memberModel;
    try {
      await authInstance
          .signInWithEmailAndPassword(email: mail, password: pwd)
          .then((value) {
            memberModel = MemberModel(value.user!.uid);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Erreur : ${e.toString()}");
      }
    }
    return memberModel;
  }

  Future<MemberModel> signUpWithEmailAndPassword(
      String email, String password) async {
    late MemberModel memberModel;
    try {
      await authInstance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        memberModel = MemberModel(value.user!.uid);

      });
    } catch (e) {
      if (kDebugMode) {
        print("Erreur : ${e.toString()}");
      }
    }
    return memberModel;
  }

  Future signOut() async {
    try {
      return await authInstance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await authInstance.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}

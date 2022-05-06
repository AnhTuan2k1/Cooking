import 'package:cooking/resource/firestore_api.dart';
import 'package:cooking/screen/notification/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*class GoogleProvider {
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static GoogleSignInAccount? get user => _googleSignIn.currentUser;

  static Future login() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credentical = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credentical);
  }

  static Future<void> logout() async {
    await _googleSignIn.disconnect();
    return await FirebaseAuth.instance.signOut();
  }
}*/

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credentical = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance
          .signInWithCredential(credentical)
          .then((userCredentical) {
        if (userCredentical.additionalUserInfo != null) {
          if (userCredentical.additionalUserInfo!.isNewUser &&
              userCredentical.user != null) {
            FirestoreApi.createUser(
                user.id,
                userCredentical.user!.photoURL,
                userCredentical.user!.displayName);
          }
        }
      });
    } on Exception catch (e) {
      showToastAndroidAndiOS(e.toString());
    }

    notifyListeners();
  }

  Future logout() async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

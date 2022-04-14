


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleProvider{

  static GoogleSignIn _googleSignIn = GoogleSignIn();

  static GoogleSignInAccount? get user => _googleSignIn.currentUser;

  static Future login() async{

    final googleUser = await _googleSignIn.signIn();
    if(googleUser == null ) return;

    final googleAuth = await googleUser.authentication;
    final credentical = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credentical);

  }

  static Future<void> logout() async{
    await _googleSignIn.disconnect();
    return await FirebaseAuth.instance.signOut();
  }


}
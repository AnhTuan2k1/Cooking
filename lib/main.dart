import 'package:cooking/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'main_page.dart';
import 'screen/login/login_with_gg_page.dart';

 main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasData){
              return const MainPage();
            }
            else if(snapshot.hasError){
              return const Center(child: Text(' auth stream user error'),);
            }
            else {
              return const LoginWithGGPage();
            }

          },
        ),
      ),
    );
  }
}

/*
StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.hasData){
                return const MainPage();
              }
              else if(snapshot.hasError){
                return const Center(child: Text(' auth stream user error'),);
              }
              else {
                return const LoginWithGGPage();
              }

            },
            ),
 */
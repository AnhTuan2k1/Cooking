import 'package:cooking/provider/google_sign_in.dart';
import 'package:cooking/provider/myfood_provider.dart';
import 'package:cooking/provider/news_feed_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';
import 'screen/login/login_with_gg_page.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<String>("searchHistory");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsFeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyFoodProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const MainPage();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(' auth stream user error'),
              );
            } else {
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
/*
//import 'package:cooking/screen/news/test.dart';
import 'package:cooking/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          // ignore: curly_braces_in_flow_control_structures
          return const Center(child: CircularProgressIndicator(),);
        else if(snapshot.hasError)
          // ignore: curly_braces_in_flow_control_structures
          return Center(child: Text(snapshot.error?.toString() ?? 'error'));
        else

        // ignore: curly_braces_in_flow_control_structures
        return Scaffold(
          appBar: AppBar(
            title: FirebaseAuth.instance.currentUser == null
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.googleLogin();
                  });
                },
                child: CircleAvatar(backgroundColor: Colors.red, child: Text('login'))
            )
                : GestureDetector(
                onTap: () {
                  setState(() {

                  });
                },
                child: CircleAvatar(backgroundColor: Colors.green, child: Text('logout'))
            ),
          ),

        );
      }
    );
  }
}
*/

import 'package:cooking/provider/google_sign_in.dart';
import 'package:cooking/resource/firestore_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';
import '../../widget/Drop_btn.dart';
import '../notification/toast.dart';
import '../search_food/food_detail_page.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser == null) print('---------------null----------');
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: buildAppBar(user),
      body: Column(children: [
        ElevatedButton(
          child: Text('click'),
          onPressed: () async {
            await FirestoreApi.createFood();
            print('s');
          },
        ),
        Expanded(
          child: StreamBuilder<List<Food>>(
              stream: FirestoreApi.readAllFoods(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return buidfoods(snapshot.data?.elementAt(index));
                      });
                }

                return Text("loading");
              }),
        )
      ]), // Column
    );
  }

  Widget buidfoods(Food? food) {
    if (food != null) {
      return GestureDetector(
        child: Card(
          margin: EdgeInsets.only(top: 20, right: 10, left: 10),
          elevation: 2,
          child: Row(
            children: [
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.network(
                      food.image ?? FoodApi.defaulFoodUrl,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: Text(food.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(food.description),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FoodDetail(food: food)));
        },
      );
    } else
      return Text('h');
  }

  AppBar buildAppBar(User user) {
    return AppBar(
      leading: Container(
          margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
          child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? urlDragonAvatar))),
      title: ListTile(
          title: Text(user.displayName ?? 'no name'),
          subtitle: Text(user.email ?? 'no email')),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8.0),
          child: PopupMenuButton(
              onSelected: (WhyFarther result) {
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

                provider.logout();
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.harder,
                      child: Text('Đăng xuất'),
                    ),
                  ],
              child: Icon(Icons.more_vert_outlined)),
        ),
      ],
    );
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

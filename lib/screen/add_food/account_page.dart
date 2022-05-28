import 'package:cooking/screen/add_food/add_food_page.dart';
import 'package:cooking/screen/add_food/following_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/google_sign_in.dart';
import 'myfood_page.dart';
import 'save_food_page.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser?.photoURL ??
                          urlDragonAvatar)),
            ),
            title: Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'Đông Phong',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddFoodPage()));
                  },
                  child: Row(children: const [
                    Icon(Icons.add, color: Colors.black87),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Món mới',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ]),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: PopupMenuButton(
                    onSelected: (WhyFarther result) {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
                    },
                    itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<WhyFarther>>[
                      const PopupMenuItem<WhyFarther>(
                        value: WhyFarther.harder,
                        child: Text('Đăng xuất'),
                      ),
                    ],
                    child: const Icon(Icons.more_vert_outlined,
                        color: Colors.black)),
              ),
            ],
            bottom: const TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Món của tôi'),
                Tab(
                  text: 'Món đã lưu',
                ),
                Tab(
                  text: 'Đang theo dõi',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyFoodPage(),
              SaveFoodPage(),
              FollowingPage()
            ],
          ),
        ),
      ),
    );
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

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

import 'package:cooking/model/user.dart' as app;
import 'package:cooking/provider/google_sign_in.dart';
import 'package:cooking/resource/firestore_api.dart';
import 'package:cooking/screen/news/chat_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';

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
    if (FirebaseAuth.instance.currentUser == null)
      print('---------------null----------');
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: buildAppBar(user),
      body: FutureBuilder<List<Food>>(
          future: FirestoreApi.readAllFoodsFuture(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return buidfoods(snapshot.data?.elementAt(index), user);
                  });
            }
            return const Center(child: Text("loading"));
          }), // Column
    );
  }

  Widget buidfoods(Food? food, User myUser) {
    if (food != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FoodDetail(food: food)));
        },
        child: Card(
          margin: const EdgeInsets.only(top: 20),
          elevation: 2,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            foodInfoSection(food),
            mainSection(food),
            interactSection(food, myUser),
          ]),
        ),
      );
    } else
      return Text('h');
  }

  AppBar buildAppBar(User user) {
    return AppBar(
      backgroundColor: Colors.white,
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
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                provider.logout();
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.harder,
                      child: Text('Đăng xuất'),
                    ),
                  ],
              child: const Icon(Icons.more_vert_outlined, color: Colors.black)),
        ),
      ],
    );
  }

  Widget foodInfoSection(Food food) {
    if (food.by != null) {
      return FutureBuilder<app.User>(
          future: FirestoreApi.getUser(food.by!),
          builder: (BuildContext context, AsyncSnapshot<app.User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 50,
              );
            } else if (snapshot.hasData) {
              return buildInfo(snapshot.data!, food);
            } else if (snapshot.hasError) {
              print(snapshot.error.toString());
              return const SizedBox(
                height: 50,
              );
            } else {
              return const SizedBox(
                height: 50,
              );
            }
          });
    } else {
      return const SizedBox(
        height: 50,
      );
    }
  }

  Widget buildInfo(app.User user, Food food) {
    Duration duration =
        DateTime.now().difference(DateTime.parse(food.dateCreate));
    String time = '';

    if (duration.inMinutes < 60) {
      time = duration.inMinutes.toString() + 'm ago';
    } else if (duration.inHours < 24) {
      time = duration.inHours.toString() + 'h ago';
    } else if (duration.inDays < 30) {
      time = duration.inDays.toString() + 'days ago';
    } else {
      time = (duration.inDays / 30).toString() + 'months ago';
    }

    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.imageUrl ?? urlDragonAvatar)),
      title: Text(user.name ?? 'no name'),
      subtitle: Text(time),
      trailing: Text(food.origin ?? ''),
    );
  }

  Widget mainSection(Food food) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 5.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              food.description,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width * 0.7,
              width: double.infinity,
              child: Image.network(
                food.image ?? FoodApi.defaulFoodUrl,
                fit: BoxFit.fill,
              )),
        ]));
  }

  Widget interactSection(Food food, User myUser) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: StreamBuilder<List<String>>(
                    initialData: food.likes,
                    stream: FirestoreApi.readAllLikes(food.identify ?? ''),
                    builder: (context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData) {
                        return buildRowLike(food, myUser, snapshot);
                      } else {
                        return buildRowLike(food, myUser, snapshot, snapshot.hasData);
                      }
                    }),
              ),
              Expanded(
                flex: 3,
                child: Row(children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mode_comment_rounded,
                      color: Colors.black38,
                    ),
                  ),
                  Text(food.comments?.length.toString() ?? '0'),
                ]),
              ),
              const Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 10,
                  )),
            ],
          ),
          // comment TextField
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: CircleAvatar(
                      maxRadius: 15.0,
                      backgroundImage:
                          NetworkImage(myUser.photoURL ?? urlDragonAvatar)),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0, left: 5.0),
                    child: TextField(
                      readOnly: true,
                      decoration: const InputDecoration.collapsed(
                          hintText: ' Thêm bình luận'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                foodId: food.identify ?? 'gfjqW3QMDKnua6MDHUjd',
                                user: types.User(
                                    id: myUser.uid,
                                    lastName: myUser.displayName,
                                    imageUrl: myUser.photoURL))));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildRowLike(
      Food food, User myUser, AsyncSnapshot<List<String>> snapshot, [bool hasdata = true]) {
    return Row(children: [
      const SizedBox(
        width: 20,
      ),
      IconButton(
          onPressed: () {
            if (food.identify != null) {
              FirestoreApi.updateLike(
                  food.identify!, food.likes, food, myUser.uid);
            }
          },
          icon: Icon(Icons.thumb_up_alt_rounded,
              color: getColor(food.likes, myUser.uid))),
      hasdata ?
      Text(snapshot.data?.length.toString() ?? '0')
      : Text(food.likes?.length.toString() ?? '0')
    ]);
  }

  Color getColor(List<String>? likes, String uid) {
    if (likes != null) {
      return likes.contains(uid) ? Colors.blueAccent : Colors.black38;
    }
    return Colors.black38;
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

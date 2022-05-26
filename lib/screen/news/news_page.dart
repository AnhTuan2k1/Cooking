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
import 'package:cooking/provider/myfood_provider.dart';
import 'package:cooking/provider/news_feed_provider.dart';
import 'package:cooking/resource/firestore_api.dart';
import 'package:cooking/screen/add_food/others_account_page.dart';
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
  final controller = ScrollController();
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        hasMore = await Provider.of<NewsFeedProvider>(context, listen: false)
            .loadMoreFood();
      }
    });
    Provider.of<NewsFeedProvider>(context, listen: false).loadMoreFood();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null)
      print('---------------null----------');
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: buildAppBar(user),
      body: Consumer<NewsFeedProvider>(
        builder: (context, cart, child) {
          return ListView.builder(
              controller: controller,
              itemCount: cart.foods.length + 1,
              itemBuilder: (context, index) {
                if (index < cart.foods.length) {
                  return buidfoods(cart.foods.elementAt(index), user);
                } else {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                          child: hasMore
                              ? const CircularProgressIndicator()
                              : const Text('no more data')));
                }
              });
        },
      ), // Column
    );
  }

  Widget buidfoods(Food? food, User myUser) {
    if (food != null) {
      return Card(
        margin: const EdgeInsets.only(top: 20),
        elevation: 2,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          foodInfoSection(food),
          mainSection(food),
          interactSection(food, myUser),
        ]),
      );
    } else
      return Text('h');
  }

  AppBar buildAppBar(User user) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: TextField(
        onSubmitted: (keys){
          Provider.of<NewsFeedProvider>(context, listen: false).loadSearchFood(keys: keys);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          contentPadding: const EdgeInsets.all(15),
          //filled: true,
          hintText: 'Nhập để tìm món ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );

      AppBar(
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
                height: 72,
              );
            } else if (snapshot.hasData) {
              return buildInfo(snapshot.data!, food);
            } else if (snapshot.hasError) {
              print(snapshot.error.toString());
              return const SizedBox(
                height: 72,
              );
            } else {
              return const SizedBox(
                height: 72,
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

    return Row(children: [
      Expanded(
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl ?? urlDragonAvatar)),
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OtherAccountPage(user: user)));
                },
                child: Text(user.name ?? 'no name')),
          ]),
          subtitle: Text(time),
          trailing: Text(food.origin ?? ''),
        ),
      ),
      GestureDetector(
        onTap: () {
          FirestoreApi.updateSaveFood(food.identify ?? 'g546qVbGhHFOtyjts1rV');
        },
        child: StreamBuilder<bool>(
            stream: FirestoreApi.isSaveFood(
                food.identify ?? 'tR5n6UJEPmUQtpRNXpUCGAmsyxy1'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print('-------------folow1----------');
                return buildSaveFood(snapshot.data ?? true);
              } else {
                 print('-------------Show saveFood error----------');
                return buildSaveFood(snapshot.data ?? false);
              }
            }),
      ),
    ]);
  }

  Widget buildFollow(bool isfollow) {
    Color color = isfollow ? Colors.lightGreen : Colors.black45;
    return Row(children: [
      Icon(
        Icons.stars_sharp,
        color: color,
      ),
      Text(
        isfollow ? " Đang theo dõi" : " Theo dõi",
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
      )
    ]);
  }

  Widget buildSaveFood(bool isSave) {
    Color color = isSave ? Colors.lightGreen : Colors.black45;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
      child: Tooltip(
        message: 'save this food',
        child: Icon(
          Icons.bookmark,
          color: color,
        ),
      ),
    );
  }

  Widget mainSection(Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FoodDetail(food: food)));
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 5.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                food.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
          ])),
    );
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
                    stream: FirestoreApi.readAllLikes(food.identify ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildRowLike(food, myUser, snapshot);
                      } else {
                        return buildRowLike(food, myUser, snapshot);
                      }
                    }),
              ),
              Expanded(
                flex: 3,
                child: StreamBuilder<List<types.TextMessage>>(
                    stream: FirestoreApi.readAllComments(food.identify ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildRowComment(food, myUser, snapshot);
                      } else {
                        return buildRowComment(food, myUser, snapshot);
                      }
                    }),
              ),
              const Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 10,
                  )),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Divider(
              thickness: 1.0,
              color: Colors.black12,
            ),
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
      Food food, User myUser, AsyncSnapshot<List<String>> snapshot) {
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
      snapshot.hasData
          ? Text(snapshot.data?.length.toString() ?? '0')
          : Text(food.likes?.length.toString() ?? '0')
    ]);
  }

  Row buildRowComment(
      Food food, User myUser, AsyncSnapshot<List<types.TextMessage>> snapshot) {
    return Row(children: [
      IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatPage(
                  foodId: food.identify ?? 'gfjqW3QMDKnua6MDHUjd',
                  user: types.User(
                      id: myUser.uid,
                      lastName: myUser.displayName,
                      imageUrl: myUser.photoURL))));
        },
        icon: const Icon(
          Icons.mode_comment_rounded,
          color: Colors.black38,
        ),
      ),
      snapshot.hasData
          ? Text(snapshot.data?.length.toString() ?? '0')
          : Text(food.comments?.length.toString() ?? '0'),
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

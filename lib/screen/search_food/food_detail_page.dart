import 'package:cooking/model/comment.dart';
import 'package:cooking/model/method.dart';
import 'package:cooking/model/user.dart' as app;
import 'package:cooking/resource/app_foods_api.dart';
import 'package:cooking/screen/news/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/food.dart';
import '../../provider/google_sign_in.dart';
import '../../resource/firestore_api.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';

class FoodDetail extends StatelessWidget {
  const FoodDetail({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  Widget build(BuildContext context) {
    addSearchHistory(food.identify!);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(food.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
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
          )
        ],
      ),
      body: Material(
        child: ListView(
          children: [
            Image.network(
              food.image ?? FoodApi.defaulFoodUrl,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: Column(
                children: [
                  infoSection(food),
                  const Divider(thickness: 1),
                  ingredientSection(food.ingredients),
                  const Divider(thickness: 1),
                  methodSection(food.method),
                  const Divider(thickness: 1),
                  MessageSection(food.comments, context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  infoSection(Food food) {

    return Column(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              food.name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        food.by != null
            ? FutureBuilder(
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
            })
            : ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.purpleAccent),
            title: Text(food.by ?? "admini"),
            subtitle: Row(children: [
              const Icon(Icons.location_on_outlined),
              Text(food.origin ?? '...'),
            ])),

        const Divider(thickness: 1),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time),
                  Text(' ${food.cookTime} phút')
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.people_alt),
                  Text(' ${food.serves} người')
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  buildInfo(app.User user, Food food) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(user.imageUrl ?? urlDragonAvatar)),
      title: Text(user.name ?? 'no name'),
      subtitle:  Row(children: [
        const Icon(Icons.location_on_outlined),
        Text(food.origin ?? '...'),
      ]),
      trailing: Text(food.origin ?? ''),
    );
  }

  ingredientSection(List<String> ingredients) {
    List<Widget> list = <Widget>[];

    for (int i = 0; i < ingredients.length; i++) {
      list.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text(ingredients[i])));
      if (i < ingredients.length - 1)
        // ignore: curly_braces_in_flow_control_structures
        list.add(const Divider(thickness: 0.5));
    }

    return Column(children: [
      Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nguyên Liệu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: list)
    ]);
  }

  methodSection(List<Method> method) {
    List<Widget> list = <Widget>[];
    for (int i = 0; i < method.length; i++) {
      list.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Text((i + 1).toString()),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method[i].content),
                  const SizedBox(height: 10),
                  getImagesDependOnDirectory(food.by == null
                      ? 'appfoods/${food.identify}/step${food.method[i].stepid}'
                      : 'userfoods/${food.identify}/step${food.method[i].stepid}'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(width: 10)
          ].toList()));
    }

    return Column(children: [
      Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Cách làm',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: list)
    ]);
  }

  Widget getImagesDependOnDirectory(String path) {
    return FutureBuilder<List<String>>(
        future: FoodApi.listAllImageUrls(path),
        builder: (context, snapshot) {
          List<String>? imageLinks = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting)
            // ignore: curly_braces_in_flow_control_structures
            return const Center(child: CircularProgressIndicator());
          else if (snapshot.hasError)
            // ignore: curly_braces_in_flow_control_structures
            return Center(child: Text(snapshot.error.toString()));
          else if (imageLinks != null) {
            return SizedBox(
              height: imageLinks.isEmpty ? 0.0 : 100.0,
              child: ListView.builder(
                  itemCount: imageLinks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: FoodApi.getImage(imageLinks[index]));
                  }),
            );
          }

          // ignore: curly_braces_in_flow_control_structures
          else {
            return const Text("food api sos");
          }
        });
  }

  MessageSection(List<Comment>? comments, BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    if (user == null || food.by == null) return SizedBox();

    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.mode_comment_outlined),
              Text(
                ' Bình luận',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL ?? urlDragonAvatar)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                    child: TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50))),
                        labelText: ' Thêm bình luận',
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                foodId: food.identify ?? 'gfjqW3QMDKnua6MDHUjd',
                                user: types.User(
                                    id: user.uid,
                                    lastName: user.displayName,
                                    imageUrl: user.photoURL))));
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
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
          size: 35,
        ),
      ),
    );
  }

  void addSearchHistory(String foodId) async{
    Box<String> searchHistory = Hive.box<String>('searchHistory');
    List<String> history = searchHistory.values.toList();

    if(searchHistory.values.contains(foodId)){
      history.remove(foodId);
      history.insert(0, foodId);
    }else{
      history.insert(0, foodId);
      if(history.length > 10){
        history = history.take(10).toList();
      }
    }
    await searchHistory.clear();
    await searchHistory.addAll(history);

    print('${history}-----------------search--------');
  }
}
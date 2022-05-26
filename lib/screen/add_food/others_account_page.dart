import 'package:cooking/provider/myfood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../model/user.dart';
import '../../resource/app_foods_api.dart';
import '../../resource/firestore_api.dart';
import '../search_food/food_detail_page.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';

class OtherAccountPage extends StatelessWidget {
  const OtherAccountPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
   Provider.of<MyFoodProvider>(context, listen: false).loadFood(user.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.0, left: 10.0),
        child: Column(
          children: [
            buildInfo(),
            buildFollowing(),
            buildSearchFood(context),
            buildUserFood(),
          ],
        ),
      ),
    );
  }

  SizedBox buildFollowing() {
    return SizedBox(
            height: 35.0,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (){
                FirestoreApi.updateFollowing(user.id);
              },
              child: StreamBuilder<bool>(
                  stream: FirestoreApi.isFollowing(user.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print('-------------folow1----------');
                      return buildFollow(snapshot.data ?? true);
                    } else {
                      print('-------------Show folow error----------');
                      return buildFollow(snapshot.data ?? false);
                    }
                  }),
            ),
          );
  }

  Row buildInfo() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: CircleAvatar(
                  radius: 40,
                  foregroundImage:
                      NetworkImage(user.imageUrl ?? urlDragonAvatar),
                ),
              ),
              Column(
                children: [
                  Text(
                    user.name ?? 'no name',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          );
  }

  Widget buildFollow(bool isfollow) {
    Color color = isfollow ? Colors.lightGreen : Colors.black45;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

  Widget buildUserFood() {
    return Consumer<MyFoodProvider>(
      builder: (context, cart, child) {
        return buildGridfood(cart.foods, context);
      },
    );

      FutureBuilder<List<Food>>(
      future: FirestoreApi.readFoodsByUserFuture(user.id, ),
      builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return buildGridfood(snapshot.data!, context);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(' auth stream user error'),
          );
        } else {
          return buildNoneFood();
        }
      },
    );
  }

  Widget buildGridfood(List<Food> foods, BuildContext context) {
    List<Widget> list = <Widget>[];
    foods.forEach((food) {
      list.add(GestureDetector(
        child: Card(
          margin: const EdgeInsets.only(top: 20),
          elevation: 2,
          child: Row(
            children: [
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Container(
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: Text(food.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(food.description),
                    ),
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
      ));
    });
    return list.isEmpty ? buildNoneFood() : Column(children: list);
  }

  Widget buildNoneFood() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: const [
          Text(
            'Hông có món nào hết 🙄',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildSearchFood(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
        onSubmitted: (keys){
          Provider.of<MyFoodProvider>(context, listen: false).loadFood(user.id, keys: keys);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          hintText: 'Tìm món của ${user.name}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

import 'package:cooking/resource/firestore_api.dart';
import 'package:flutter/material.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';
import '../search_food/food_detail_page.dart';

class MyFoodPage extends StatelessWidget {
  const MyFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(15),
                  filled: true,
                  hintText: 'Tìm món của tôi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<Food>>(
            future: FirestoreApi.readMyFoodsFuture(),
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
          )
        ]),
      ),
    );
  }

  Widget buildGridfood(List<Food> foods, BuildContext context) {
    List<Widget> list = <Widget>[];
    foods.forEach((food) {
      list.add(GestureDetector(
        child: Card(
          margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
          elevation: 2,
          child: Row(
            children: [
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Container(
                    padding: const EdgeInsets.all(5),
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
      ));
    });
    return list.isEmpty ? buildNoneFood() : Column(children: list);
  }

  Widget buildNoneFood() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: const [
          Text(
            'Chưa có món nào hết 🙄',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Bạn vẫn chưa đăng món nào. Hãy chia sẻ món bạn yêu thích và ban sẽ thấy món ấy ở đây nhé 😘',
          )
        ],
      ),
    );
  }
}

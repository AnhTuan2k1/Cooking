import 'package:cooking/screen/search_food/search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';
import 'food_detail_page.dart';

class SearchFoodPage extends StatelessWidget {
  const SearchFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.search),
            title: Text("Tìm các món ăn hoặc nguyên liệu"),
          ),
          onTap: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(children: [
          if (Hive.box<String>('searchHistory').length != 0)
            Container(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Món bạn đã xem',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ValueListenableBuilder(
              valueListenable: Hive.box<String>('searchHistory').listenable(),
              builder: (context, Box<String> box, _) {
                return historyFood(context);
              },
          ),
          Container(
            padding: const EdgeInsets.only(left: 5.0, top: 10.0),
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Món gợi ý',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Table(
            children: [
              TableRow(children: [
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/steak.png',
                    name: "Bò"),
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/chicken.jpg',
                    name: "Gà"),
              ]),
              TableRow(children: [
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/fish.jpg',
                    name: "Cá"),
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/shrimp.jpg',
                    name: "Tôm"),
              ]),
              TableRow(children: [
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/squid.jpg',
                    name: "Mực"),
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/duck.jpg',
                    name: "Vịt"),
              ]),
              TableRow(children: [
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/pork.jpg',
                    name: "Heo"),
                buildSuggestionFood(
                    context: context,
                    path: 'assets/images/noodle.jpg',
                    name: "Phở"),
              ]),
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildSuggestionFood(
      {required BuildContext context,
      required String path,
      required String name}) {
    double roundborder = 10.0;
    return GestureDetector(
      onTap: () {
        showSearch(
            context: context, delegate: CustomSearchDelegate(), query: name);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        height: MediaQuery.of(context).size.width / 2.2,
        //padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundborder),
          ),
          child: Stack(children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(roundborder),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(path),
                ),
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              alignment: Alignment.bottomLeft,
            ),
          ]),
        ),
      ),
    );
  }

  Widget historyFood(BuildContext context) {
    return FutureBuilder<List<Food>>(
        future: FoodApi.readAllFoodsFuture(context),
        builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 100,
            );
          } else if (snapshot.hasData) {
            return buildHistoryfood(snapshot.data!, context);
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const SizedBox(
              height: 100,
            );
          } else {
            return const SizedBox(
              height: 100,
            );
          }
        });

    /*return ValueListenableBuilder(
      valueListenable: Hive.box<String>('searchHistory').listenable(),
      builder: (context, Box<String> box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            Widget w = await getfood(box.values.elementAt(index));
            return w;
          },
        );
      },

    );*/
  }

/*  Future<Widget> getfood(String elementAt) async{

  }*/

  Widget buildHistoryfood(List<Food> foods, BuildContext context) {
    List<Widget> list = <Widget>[];
    double roundborder = 10.0;
    foods.forEach((food) {
      list.add(GestureDetector(
        child: SizedBox(
          height: 140,
          width: 120,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundborder),
            ),
            margin: const EdgeInsets.only(top: 5.0, left: 10, bottom: 10.0),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(roundborder),
                  child: Image(
                    width: 120,
                    height: 90,
                    fit: BoxFit.fill,
                    image: NetworkImage(food.image ?? FoodApi.defaulFoodUrl),
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, right: 5.0, left: 5.0),
                        child: Text(food.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FoodDetail(food: food)));
        },
      ));
    });
    double height = list.length == 0 ? 0 : 140;
    return SizedBox(
      height: height,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: list),
    );

  }

  Text buildTextNameUser(Food food) => Text(
        food.by ?? 'admin',
        style: TextStyle(fontSize: 10),
      );
}

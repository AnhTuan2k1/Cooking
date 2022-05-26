


import 'package:flutter/material.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';
import 'food_detail_page.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Food>? foodss;

  CustomSearchDelegate()
      : super(
      keyboardType: TextInputType.text,
      searchFieldLabel: "Nhập tên món ăn hoặc nguyên liệu",
      searchFieldStyle: TextStyle(color: Colors.black26, fontSize: 15));
  List<String> searchTerms = <String>["sdf", "abc", "lkj"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
    IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
/*    List<String> matchQuery = [];
    for (var food in searchTerms) {
      if (food.toLowerCase().contains((query.toLowerCase()))) {
        matchQuery.add(food);
      }
    }
    ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Card(
            child: ListTile(
              title: Text(result),
            ),
          );
        });*/

    List<String> querys = query.split(' ');

    return FutureBuilder<List<Food>>(
      future: FoodApi.getSearchFoodsLocally(querys, context),
      builder: (context, snapshot) {
        final List<Food>? foods = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else if (foods != null)
              return buildSearchFoods(foods);
            else
              return Text("null");
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: FoodApi.getSearchFoodsLocally(query.split(' '), context),
      builder: (context, snapshot) {
        final List<Food>? foods = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else if (foods != null)
              return buildSearchFoods(foods);
            else
              return Text("null");
        }
      },
    );
  }

  Widget buildSearchFoods(List<Food> foods) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodDetail(food: food)));
          },
        );
      },
    );
  }
}
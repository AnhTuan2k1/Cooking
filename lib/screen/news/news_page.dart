


//import 'package:cooking/screen/news/test.dart';
import 'package:flutter/material.dart';

import '../../model/food.dart';
import '../../resource/app_foods_api.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: FoodApi.getFoodsLocally(context),
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
            /*onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestPage(food: food)));
            },*/
          );
        },
      );
    }

//FoodApi.getImagesDepenOnDirectory('appfoods/${food.identify}/step${food.method[i].stepid}');


}


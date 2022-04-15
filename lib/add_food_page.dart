import 'package:cooking/resource/app_foods_api.dart';
import 'package:flutter/material.dart';

import 'model/food.dart';

const String url =
    "https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/appfoods%2Fdefaultimage.jpg?alt=media&token=e0851d87-a7e4-4c24-ae98-5d638be89b5a";

class AddFoodPage extends StatelessWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: FutureBuilder<List<Food>>(
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
                return buildFoods(foods);
              else
                return Text("null");
          }
        },
      ),
    );
  }

  Widget buildFoods(List<Food> foods) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];

        return GestureDetector(
          child: Card(
            margin: EdgeInsets.only(top: 20, right: 10, left: 10),
            child: Row(
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.network(
                      food.image ?? url,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10,0,5,10),
                          child: Text(food.name, style: TextStyle(fontWeight: FontWeight.bold)
                          ),),
                      Text(food.description),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            print('food tap');
          },
        );
      },
    );
  }
}

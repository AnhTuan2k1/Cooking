import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../provider/myfood_provider.dart';
import '../../resource/app_foods_api.dart';
import '../search_food/food_detail_page.dart';

class SaveFoodPage extends StatelessWidget {
  const SaveFoodPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser != null){
      String id = FirebaseAuth.instance.currentUser!.uid;
      Provider.of<MyFoodProvider>(context, listen: false).loadsaveFood(id, context);
    }
     return SingleChildScrollView(
         child: Column(
           children: [
             Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onSubmitted: (keys){
                      if(FirebaseAuth.instance.currentUser == null) return;
                      String id = FirebaseAuth.instance.currentUser!.uid;
                      Provider.of<MyFoodProvider>(context, listen: false).loadsaveFood(id, context, keys: keys);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.all(15),
                      filled: true,
                      hintText: 'Tìm món đã lưu',
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
             Consumer<MyFoodProvider>(
               builder: (context, cart, child) {
                 return buildGridfood(cart.foods, context);
               },
             )
           ],
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
        children: [
          Image.asset('assets/images/cereal.jpg'),
          const Text(
            'Chưa có món nào được lưu 🙄',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Bạn vẫn chưa lưu món nào. Hãy tìm món bạn yêu thích và lưu món đó. Bạn sẽ thấy món ấy ở đây nhé 😘',
          )
        ],
      ),
    );
  }
}
import 'package:cooking/model/method.dart';
import 'package:cooking/resource/app_foods_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/food.dart';

class FoodDetail extends StatelessWidget {
  const FoodDetail({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          FoodApi.getImage(food.image),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
            child: Column(
              children: [
                infoSection(food),
                const Divider(thickness: 1),
                ingredientSection(food.ingredients),
                const Divider(thickness: 1),
                methodSection(food.method),
              ],
            ),
          )
        ],
      ),
    );
  }

 infoSection(Food food){
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              food.name,
              style:
              TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        ListTile(
            leading: CircleAvatar(backgroundColor: Colors.purpleAccent),
            title: Text(food.by),
            subtitle: Row(children: [
              Icon(Icons.location_on_outlined),
              Text(food.origin ?? '...'),
            ])),
        const Divider(thickness: 1),
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time),
                  Text(' ${food.cookTime} phút')
                ],
              ),
              Row(
                children: [
                  Icon(Icons.people_alt),
                  Text(' ${food.serves} người')
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  ingredientSection(List<String> ingredients) {
    List<Widget> list = <Widget>[];

    for (int i = 0; i < ingredients.length; i++) {
      list.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2), child: Text(ingredients[i])));
      if(i<ingredients.length-1)
        // ignore: curly_braces_in_flow_control_structures
        list.add(const Divider(thickness: 0.5));
    }

    return Column(children:[
      Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nguyên Liệu',
            style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: list)
    ] );
  }

  methodSection(List<Method> method) {
    List<Widget> list = <Widget>[];
    for (int i = 0; i < method.length; i++) {
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Text((i+1).toString()),
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
                  SizedBox(
                      height: 100,
                      child: getImagesDependOnDirectory('appfoods/${food.identify}/step${food.method[i].stepid}')),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 10)
          ].toList()
      ));
    }

      return Column(children:[
        Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Cách làm',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: list)
      ] );
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
            return
              ListView.builder(
                  itemCount: imageLinks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: FoodApi.getImage(imageLinks[index]));
                  });
          }

          // ignore: curly_braces_in_flow_control_structures
          else return const Text("food api sos");

        });
  }

}

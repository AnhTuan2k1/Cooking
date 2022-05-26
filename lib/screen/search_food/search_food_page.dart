
import 'package:cooking/screen/search_food/search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
        child: Column(
          children:[
            Container(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Món gợi ý', style: TextStyle(fontSize: 20),)),
            ),
            Table(
              children: [
                TableRow(
                    children: [
                      buildSuggestionFood(
                          context: context, path: 'assets/images/steak.png', name: "Bò"),
                      buildSuggestionFood(
                          context: context, path: 'assets/images/chicken.jpg', name: "Gà"),
                    ]
                ),
                TableRow(
                    children: [
                      buildSuggestionFood(
                          context: context, path: 'assets/images/fish.jpg', name: "Cá"),
                      buildSuggestionFood(
                          context: context, path: 'assets/images/shrimp.jpg', name: "Tôm"),
                    ]
                ),
                TableRow(
                    children: [
                      buildSuggestionFood(
                          context: context, path: 'assets/images/squid.jpg', name: "Mực"),
                      buildSuggestionFood(
                          context: context, path: 'assets/images/duck.jpg', name: "Vịt"),
                    ]
                ),
                TableRow(
                    children: [
                      buildSuggestionFood(
                          context: context, path: 'assets/images/pork.jpg', name: "Heo"),
                      buildSuggestionFood(
                          context: context, path: 'assets/images/noodle.jpg', name: "Phở"),
                    ]
                ),
              ],
            ),
          ]
        ),
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
        showSearch(context: context, delegate: CustomSearchDelegate(), query: name);
      },
      child: Container(
        width: MediaQuery.of(context).size.width/2.2,
        height: MediaQuery.of(context).size.width/2.2,
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
}

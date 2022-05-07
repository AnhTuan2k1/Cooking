

import 'package:cooking/screen/add_food/account_page.dart';
import 'package:cooking/screen/search_food/search_food_page.dart';
import 'package:flutter/material.dart';

import 'screen/add_food/add_food_page.dart';
import 'screen/news/news_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    NewsPage(),
    SearchFoodPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: "news"),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined),label: "search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_outlined),label: "add"),
        ],

        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
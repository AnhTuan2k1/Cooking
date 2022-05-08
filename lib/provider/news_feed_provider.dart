



import 'package:flutter/material.dart';

import '../model/food.dart';
import '../model/method.dart';

class NewsFeedProvider extends ChangeNotifier {

  final List<Food> _foods = [];

  List<Food> get foods => _foods;

  void add() {
    String name = 'food name';
    String description = 'food description';
    String by = "id";
    int serves = 2;
    String dateCreate = '25-2-2002';
    List<String> ingredients = ['ingredients', 'ss'];
    List<Method> methods = <Method>[Method('stepid', 'content', null)];
    String identify = "docFood.id";
    String origin = 'Hà Tĩnh, Việt Nam';
    Food food = Food(name, description, by, serves, dateCreate, ingredients,
        methods, identify, origin, null, 65, null, null);
    _foods.add(food);

    notifyListeners();
  }

  void addAll(List<Food> foods) {

    foods.map((e) => _foods.add(e));

    notifyListeners();
  }


  void removeAll() {
    _foods.clear();

    notifyListeners();
  }
}
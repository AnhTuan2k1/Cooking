import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../model/food.dart';
import '../model/method.dart';
import '../model/user.dart';
import '../resource/firestore_api.dart';

class NewsFeedProvider extends ChangeNotifier {
  final List<Food> _foods = [];

  List<Food> get foods => _foods;

  void addAll(List<Food> foods) {
    _foods.addAll(foods);
    notifyListeners();
  }

  void removeAll() {
    _foods.clear();
    notifyListeners();
  }

  Future<bool> loadMoreFood() async {
    print('sss'); int limit = 3;
    User user = await FirestoreApi.getUser(FirebaseAuth.instance.currentUser!.uid);
    user.following ??= <String>[];

    List<Food> foods = await FirestoreApi.readOptionFoodsFuture(
        limit: 3,
        notIncludeFoods: _foods.map((e) => e.identify!).toList(),
        following: user.following!);

    // likes
    foods.sort((a, b) => -a.likes!.length.compareTo(b.likes!.length));
    //foods = foods.reversed.toList();

    // following
    foods.forEach((food) {
      user.following!.forEach((following) {
        if(food.by == following){
          int index = foods.indexOf(food);
          foods.insert(index, food);
          foods.removeAt(index + 1);
        }
      });
    });

    //time
    foods.sort((a, b) => -a.dateCreate.compareTo(b.dateCreate));



    List<Food> removeFood = <Food>[];
    for (var element in foods) {
      if(_foods.any((e) => e.identify == element.identify)){
        removeFood.add(element);
      }
    }
    for (var element in removeFood) {
      foods.remove(element);
    }

    while(foods.length > limit){
      foods.removeLast();
    }

    addAll(foods);
    if(foods.isEmpty) return false;
    else return true;

  }
}

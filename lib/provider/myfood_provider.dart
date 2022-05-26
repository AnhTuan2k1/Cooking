import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../model/food.dart';
import '../model/method.dart';
import '../model/user.dart';
import '../resource/firestore_api.dart';

class MyFoodProvider extends ChangeNotifier {
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
  void loadFood(String userId, {String keys = ''}) async{
    final fo = await FirestoreApi.readFoodsByUserFuture(userId, keys: keys);
    _foods.clear();
    addAll(fo);
  }

  void loadsaveFood(String id, {String keys = ''}) async{
    final fo = await FirestoreApi.readSaveFoodsByUserFuture(id, keys: keys);
    _foods.clear();
    addAll(fo);
  }
}

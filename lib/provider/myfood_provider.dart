import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../model/food.dart';
import '../model/method.dart';
import '../model/user.dart';
import '../resource/app_foods_api.dart';
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

  void loadsaveFood(String id, BuildContext context, {String keys = ''}) async{
    List<Food> fo = await FirestoreApi.readSaveFoodsByUserFuture(id, context, keys: keys);

    _foods.clear();
    addAll(fo);
  }
}

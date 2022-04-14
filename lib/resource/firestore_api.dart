import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking/model/method.dart';
import 'package:cooking/provider/google_sign_in.dart';
import 'package:cooking/screen/news/news_page.dart';
import 'package:flutter/material.dart';

import '../model/food.dart';

class FirestoreApi {


  static Future<bool> createFood() async {
    String? id = GoogleProvider.user?.id;
    if(id == null) return false;

    final docFood = FirebaseFirestore.instance.collection('foods').doc();

    String name = 'food name';
    String description = 'food description';
    String by = id;
    int serves = 2;
    String dateCreate = '25-2-2002';
    List<String> ingredients = ['ingredients', 'ss'];
    List<Method> methods = <Method>[Method('stepid', 'content', null)];
    String identify = docFood.id;
    String origin = 'Hà Tĩnh, Việt Nam';
    Food food = Food(name, description, by, serves, dateCreate, ingredients,
        methods, identify, origin, null, 65, null, null);


    await docFood.set(food.toJson());

    return true;
  }


  static Stream<List<Food>> readAllFoods() {
    return FirebaseFirestore.instance.collection('foods').snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }


}




import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/food.dart';

class FoodApi {
  static Future<List<Food>> getExamQuestionsLocally(
      BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString("assets/appfoods.json");
    final List body = jsonDecode(data);

    return body.map((e) => Food.fromJson(e)).toList();

  }
}
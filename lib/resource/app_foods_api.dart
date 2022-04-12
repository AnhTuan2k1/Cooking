import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/food.dart';

class FoodApi {
  static String defaulFoodUrl =
      "https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/appfoods%2Fdefaultimage.jpg?alt=media&token=e0851d87-a7e4-4c24-ae98-5d638be89b5a";

  static Image getImage(String? url) {
    if (url == null)
      // ignore: curly_braces_in_flow_control_structures
      return const Image(
        image: AssetImage('assets/images/defaultimage.jpg'),
        fit: BoxFit.cover,
      );
    else
      // ignore: curly_braces_in_flow_control_structures
      return Image.network(url);
  }

  static Future<List<Food>> getFoodsLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString("assets/appfoods.json");
    final List body = jsonDecode(data);

    return body.map((e) => Food.fromJson(e)).toList();
  }

  static Future<List<Food>> getSearchFoodsLocally(
      List<String> keys, BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString("assets/appfoods.json");
    final List body = jsonDecode(data);

    return body.map((e) => Food.fromJson(e)).where((element) {
      return keys.every((key) {
        return element.name.contains(key) ||
            element.ingredients.any((ingredient) => ingredient.contains(key));
      });
    }).toList();
  }


  static getImages(Food image) {

  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<String>> listAllImageUrls(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);

    return urls;
  }
}

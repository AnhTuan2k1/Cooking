import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking/model/comment.dart';
import 'package:cooking/model/method.dart';
import 'package:cooking/model/user.dart';
import 'package:cooking/provider/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cooking/screen/news/news_page.dart';
import 'package:flutter/material.dart';

import '../model/food.dart';

class FirestoreApi {
  static Future<bool> createFood() async {
    String? id = GoogleProvider.user?.id;
    if (id == null) return false;

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
    return FirebaseFirestore.instance.collection('foods').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }

  static Future<List<Food>> readAllFoodsFuture() async {
    final docFoods = FirebaseFirestore.instance.collection('foods');
    final snapshot = await docFoods.get();

    return snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList();
  }

  /*static Future updateMessage(String foodId, List<Comment> msg) async {
    List<Comment> comments = <Comment>[];
    msg.forEach((element) {
      comments.add(Comment(
          User(element.author.id, element.author.imageUrl,
              element.author.lastName),
          (element as types.TextMessage).text,
          element.id,
          element.type.name,
          element.createdAt));
    });

    await FirebaseFirestore.instance
        .collection('foods')
        .doc(foodId)
        .update({'comments': comments.map((e) => e.toJson()).toList()})
        .then((value) => print("comments Updated"))
        .catchError((error) => print("Failed to update comments: $error"));
  }*/

  static Future createMessage(String foodId, types.Message msg) async {
    await FirebaseFirestore.instance
        .collection('comment')
        .doc(foodId)
        .collection('comments')
        .doc(msg.id)
        .set(Comment(
                User(msg.author.id, msg.author.imageUrl, msg.author.lastName),
                (msg as types.TextMessage).text,
                msg.id,
                msg.createdAt)
            .toJson());
  }

  static Stream<List<types.TextMessage>> readAllComments(String foodId) {
    return FirebaseFirestore.instance
        .collection('comment')
        .doc(foodId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromJson(doc.data()))
            .toList()
            .map((e) => types.TextMessage(
                author: types.User(
                    id: e.user.id,
                    imageUrl: e.user.imageUrl,
                    lastName: e.user.name),
                id: e.identify,
                text: e.message,
                type: types.MessageType.text,
                createdAt: e.timeCreated))
            .toList());
  }

  static Future<List<types.TextMessage>> readAllCommentsFuture(
      String foodId) async {
    final docComments = FirebaseFirestore.instance
        .collection('comment')
        .doc(foodId)
        .collection('comments');
    final snapshot = await docComments.get();

    return snapshot.docs.map((doc) {
      Comment e = Comment.fromJson(doc.data());
      types.TextMessage text = types.TextMessage(
          author: types.User(
              id: e.user.id, imageUrl: e.user.imageUrl, lastName: e.user.name),
          id: e.identify,
          text: e.message,
          type: types.MessageType.text,
          createdAt: e.timeCreated);

      return text;
    }).toList();
  }

/*  static Stream<List<Comment>> readAllMessage(String foodId) {
    return FirebaseFirestore.instance.collection('foods').doc(foodId)
        .snapshots().map((event) => null)

  }*/
}

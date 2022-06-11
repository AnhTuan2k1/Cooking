import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking/model/comment.dart';
import 'package:cooking/model/method.dart';
import 'package:cooking/model/user.dart';
import 'package:cooking/provider/google_sign_in.dart';
import 'package:cooking/resource/app_foods_api.dart';
import 'package:cooking/screen/notification/toast.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cooking/screen/news/news_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/food.dart';

class FirestoreApi {
  static Future<bool> createFood() async {
    String id = FirebaseAuth.instance.currentUser!.uid;

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

  static Future<bool> createUserFood(
      String namefood,
      String scriptfood,
      int serves,
      String date,
      List<String> ingre,
      List<Method> steps,
      String? ori,
      String img,
      int cookTime) async {
    try {
      String id = FirebaseAuth.instance.currentUser!.uid;

      final docFood = FirebaseFirestore.instance.collection('foods').doc();

      await FoodApi.uploadFile(
          File(img), 'userfoods/${docFood.id}', namefood + Uuid().v1());
      //print('----------okok2----------${docFood.id}------');
      List<String> imgs =
          await FoodApi.listAllImageUrls('userfoods/${docFood.id}/');
      print('----------okok----------${imgs.first}');
      img = imgs.first;

      _saveStepsImages(steps, docFood);

      //String name = namefood;
      //String description = scriptfood;
      String by = id;
      //int serves = 2;
      //String dateCreate = date;
      //List<String> ingredients = ingre;
      // List<Method> methods = steps;
      String identify = docFood.id;
      //String? origin = ori;
      Food food = Food(namefood, scriptfood, by, serves, date, ingre, steps,
          identify, ori, img, cookTime, <String>[], null);

      await docFood.set(food.toJson());
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  static _saveStepsImages(
      List<Method> steps, DocumentReference<Map<String, dynamic>> docFood) {
    steps.forEach((step) {
      step.image?.forEach((image) {
        FoodApi.uploadFile(File(image),
            'userfoods/${docFood.id}/step${step.stepid}', Uuid().v1());
      });
    });
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

  static Future<List<Food>> readMyFoodsFuture() async {
    String id = FirebaseAuth.instance.currentUser!.uid;

    final docFoods = FirebaseFirestore.instance
        .collection('foods')
        .where('by', isEqualTo: id);
    final snapshot = await docFoods.get();

    return snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList();
  }

  static Future<List<Food>> readFoodsByUserFuture(String userId,
      {String keys = ''}) async {
    final docFoods = FirebaseFirestore.instance
        .collection('foods')
        .where('by', isEqualTo: userId);

    final snapshot = await docFoods.get();

    return snapshot.docs
        .map((doc) => Food.fromJson(doc.data()))
        .where((food) => food.name.contains(keys))
        .toList();
  }

  static Future<List<Food>> readSaveFoodsByUserFuture(String userId, BuildContext context,
      {String keys = ''}) async {
    User user = await getUser(userId);
    if(user.savefood == null) return <Food>[];
    else if(user.savefood?.isEmpty??false) return <Food>[];

    final docFoods = FirebaseFirestore.instance
        .collection('foods')
        .where('identify', whereIn: user.savefood);
    final snapshot = await docFoods.get();

    List<Food> remote = snapshot.docs
        .map((doc) => Food.fromJson(doc.data()))
        .where((food) => food.name.contains(keys))
        .toList();

    List<Food> local = await FoodApi.getFoodsLocally(context);
    local = local.where((element) => user.savefood!.contains(element.identify!)).toList();
    
    local.addAll(remote);
    return local;
  }

  static Future<List<Food>> readSearchFood({String keys = ''}) async{
    final docFoods = FirebaseFirestore.instance
        .collection('foods');

    final snapshot = await docFoods.get();
    return snapshot.docs
        .map((doc) => Food.fromJson(doc.data()))
        .where((food) => food.name.toLowerCase().contains(keys.toLowerCase()))
        .toList();
  }

  static Future<List<Food>> readOptionFoodsFuture(
      {int limit = 2,
      required List<String> notIncludeFoods,
      required List<String> following}) async {
    final docFoods = FirebaseFirestore.instance.collection('foods');

/*    if (notIncludeFoods.length > 10){
      int range = notIncludeFoods.length - 10;
      docFoods.where('identify',
          whereNotIn: notIncludeFoods.where((element) =>
          notIncludeFoods.indexOf(element) >= range).toList());
    }
    else {
      docFoods.where('identify', whereNotIn: notIncludeFoods);
    }

    if (following.isNotEmpty) {
      if(following.length < 10){
        docFoods.where('by', whereIn: following);
      }
    }*/
    // docFoods.orderBy('likes').limit(limit);

    final snapshot = await docFoods.get();
    List<Food> list =
        snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList();

    return list;
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
                User(msg.author.id, msg.author.imageUrl, msg.author.lastName,
                    null, <String>[]),
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
        .orderBy('timeCreated', descending: true)
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

  static Future createLike(String foodId, String userId) async {
    await FirebaseFirestore.instance.collection('like').doc(foodId).set(
        {userId: userId}).onError((e, _) => print("Error writing like: $e"));
  }

  static Future updateLike(
      String foodId, List<String>? likes, Food food, String myUserUid) async {
    food.likes ??= <String>[];
    if (food.likes!.contains(myUserUid)) {
      food.likes!.remove(myUserUid);
    } else {
      food.likes!.add(myUserUid);
    }

    await FirebaseFirestore.instance
        .collection('foods')
        .doc(foodId)
        .set(food.toJson())
        .onError((e, _) => print("Error writing updatelike: $e"));

    /*.update({"likes": likes}).then(
            (value) => print("$foodId likes successfully updated!"),
        onError: (e) => print("Error updating likes $e"));*/
  }

  static Stream<List<String>> readAllLikes(String foodId) {
    return FirebaseFirestore.instance
        .collection('foods')
        .doc(foodId)
        .snapshots()
        .map((snapshot) {
      return (snapshot.get('likes') as List)
          .map((item) => item as String)
          .toList();
    });
  }

  static Future createUser(
      String userId, String? imageUrl, String? name) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .set(User(userId, imageUrl, name, null, <String>[]).toJson())
        .then((value) => print('create user ok - fireStore'),
            onError: (error) =>
                showToastAndroidAndiOS('fail to create user - fireStore'));
  }

  static Future<User> getUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    final User u;

    snapshot.data() != null
        ? u = User.fromJson(snapshot.data()!)
        : u = User('no id', null, null, null, <String>[]);

    return u;
  }

  static Future updateFollowing(String following) async {
    //print(FirebaseAuth.instance.currentUser);
    if (FirebaseAuth.instance.currentUser == null) return;
    String id = FirebaseAuth.instance.currentUser!.uid;
    User user = await getUser(id);

    user.following == null
        ? user.following = <String>[following]
        : user.following!.contains(following)
            ? user.following!.remove(following)
            : user.following!.add(following);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.id)
        .set(user.toJson())
        .then((value) => print('update following ok - fireStore'),
            onError: (error) =>
                showToastAndroidAndiOS('fail to update following - fireStore'));
  }

  static Future<List<User>> getAllFollowingUser() async {
    if (FirebaseAuth.instance.currentUser == null) return <User>[];
    String id = FirebaseAuth.instance.currentUser!.uid;
    User user = await getUser(id);

    print(user.following);
    List<User> users = <User>[];
    if(user.following == null) return <User>[];
    else {
      for (var userId in user.following!) {
        User u = await getUser(userId);
        users.add(u);
      }
    }

    await users;
    return users;
  }

  static Stream<bool> isFollowing(String following) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      print(snapshot.data().runtimeType);
      // print((snapshot.get('following') as List).map((item) => item as String).toList().contains(following).runtimeType);
      return (snapshot.get('following') as List)
          .map((item) => item as String)
          .toList()
          .contains(following);
    });
  }

  static Future updateSaveFood(String foodId) async {
    if (FirebaseAuth.instance.currentUser == null) return;
    String id = FirebaseAuth.instance.currentUser!.uid;
    User user = await getUser(id);

    user.savefood == null
        ? user.savefood = <String>[foodId]
        : user.savefood!.contains(foodId)
            ? user.savefood!.remove(foodId)
            : user.savefood!.add(foodId);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.id)
        .set(user.toJson())
        .then((value) => print('update savefood ok - fireStore'),
            onError: (error) => showToastAndroidAndiOS(
                'fail to savefood following - fireStore'));
  }

  static Stream<bool> isSaveFood(String foodId) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      print(snapshot.data().runtimeType);
      return (snapshot.get('savefood') as List)
          .map((item) => item as String)
          .toList()
          .contains(foodId);
    });
  }

  static deleteFood(String foodId) {
    FirebaseFirestore.instance
        .collection('foods').doc(foodId).delete()
        .then((value) => print("food Deleted"))
        .catchError((error) => print("Failed to delete food: $error"));

  }
}

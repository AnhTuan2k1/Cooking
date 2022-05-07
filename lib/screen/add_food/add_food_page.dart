import 'dart:io';

import 'package:cooking/model/ingredient.dart';
import 'package:cooking/model/method.dart';
import 'package:cooking/resource/app_foods_api.dart';
import 'package:cooking/resource/firestore_api.dart';
import 'package:cooking/screen/notification/toast.dart';
import 'package:cooking/widget/method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../model/food.dart';
import '../../provider/google_sign_in.dart';
import '../../widget/ingredient.dart';
import '../dialog/alert_dialog.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  File? image;
  String? nameFood;
  String? descriptionFood;
  String? origin;
  int serves = 2;
  int cookTime = 75;
  List<Ingredient> ingredients = <Ingredient>[];
  List<Method> steps = <Method>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                if (await checkdata(context)) saveFood();
              },
              child: Text(
                'Lưu Món',
                style: TextStyle(color: Colors.black),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black12,
                side: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await pickImage();
              },
              child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.bottomCenter,
                  children: [
                    image == null
                        ? const Image(
                      image: AssetImage('assets/images/foodAvatar.png'),
                      fit: BoxFit.cover,
                    )
                        : Image.file(image!,
                        width: double.infinity,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .35,
                        fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined),
                            Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  '  Đăng hình đại diện món ăn',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ))
                          ]),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: infoSection(),
            ),
            Container(
              width: double.infinity,
              height: 6,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ingredientSection(),
            ),
            Container(
              width: double.infinity,
              height: 6,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: methodSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: TextField(
            onChanged: (value) => nameFood = value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              filled: true,
              hintText: 'Nhập tên món ăn',
              hintStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          //constraints: ,
          margin: const EdgeInsets.only(top: 10),
          child: TextField(
            onChanged: (value) => descriptionFood = value,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              hintText:
              'Thêm mô tả về món này. Món này đến từ đâu? Ai đã truyền cảm hứng cho bạn, tại sao nó đặc biệt, bạn nấu món này cho ai?',
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Khẩu Phần',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                width: 180,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextField(
                    onChanged: (value) => serves = int.parse(value),
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      filled: true,
                      hintText: '2 (người)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Thời gian nấu',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      onChanged: (value) => cookTime = int.parse(value),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        hintText: '75 (phút)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget ingredientSection() {
    return Ingredients(ingredient: ingredients);
  }

  Widget methodSection() {
    return Methods(steps: steps);
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imagetemporary = File(image.path);
      setState(() {
        this.image = imagetemporary;
      });
    } on Exception catch (e) {
      showToast(context, e.toString());
    }
  }

  void saveFood() {
    buildShowDialogProgress(context);
    List<String> ingre = <String>[];
    ingredients.forEach((element) => ingre.add(element.content));
    String img = image?.path??'';

    FirestoreApi.createUserFood(
        nameFood ?? '',
        descriptionFood ?? '',
        serves,
        DateTime.now().toString(),
        ingre,
        steps,
        origin,
        img,
        cookTime)
        .then((value) {
      Navigator.of(context).pop();
      print(value);
      if(value) {
        cleardata(context);
      } else {
        showToastAndroidAndiOS('error');
      }
    }
    );
    /*   Food food = new Food(nameFood??'', descriptionFood??'',
        userId, serves,  DateTime.now().toString(),
        ingre, steps, Uuid().v1(), origin,img,cookTime,null,null);*/
  }

  Future<bool> checkdata(BuildContext context) async {
    String? error;
    if (image == null)
      error = "Thêm ảnh đại diện món ăn điii";
    else if (nameFood == null)
      error = "đặt tên cho món ăn đi nào :v";
    else if (descriptionFood == null)
      error = "thêm mô tả cho món ăn nữa kìa.";
    else if (ingredients.every((element) => element.content.isEmpty))
      error = "u là tr. Thêm nguyên liệu zô";
    else if (steps.every((element) => element.content.isEmpty))
      error = 'thêm cách làm món ăn này nữa chớ bạn 🤤';

    if (error != null) {
      await showAlertDialog(context: context, content: error);
      return false;
    } else return true;

  }

   cleardata(BuildContext context) {
     Navigator.pop(context);
     showToastAndroidandiOS('Thêm món thành công 🤗', Colors.green, Colors.white);
  }

  buildShowDialogProgress(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }


}

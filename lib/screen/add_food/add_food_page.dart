import 'dart:io';

import 'package:cooking/resource/app_foods_api.dart';
import 'package:cooking/screen/notification/toast.dart';
import 'package:cooking/widget/method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../model/food.dart';
import '../../widget/ingredient.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black,),
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
                            height: MediaQuery.of(context).size.height * .35,
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
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                              padding: const EdgeInsets.all(8.0),

                                child: const Text(
                                  '  Đăng hình đại diện món ăn',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
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
    return Ingredients();
  }

  Widget methodSection() {
    return Methods();
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
}

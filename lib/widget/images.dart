import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screen/notification/toast.dart';

class Images extends StatefulWidget {
  const Images({Key? key}) : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  List<Widget> images = <Widget>[];
  List<String> imagesPath = <String>[];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {

          if (index < images.length) {
            return PopupMenuButton(
                onSelected: (WhyFarther result) {
                  setState(() {
                    images.removeAt(index);
                    imagesPath.removeAt(index);
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<WhyFarther>>[
                      const PopupMenuItem<WhyFarther>(
                        value: WhyFarther.harder,
                        child: Text('Delete this image'),
                      ),
                    ],
                child: images[index]
            );

          } else {
            return GestureDetector(
              onTap: () async {
                await pickImage();
              },
              child: Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                color: Colors.black12,
                width: 105,
                child: Icon(Icons.camera_alt_outlined),
              ),
            );
          }
        });
  }

  Widget createImage(File file) {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, right: 5.0),
      color: Colors.black12,
      width: 100,
      child: Image.file(file, fit: BoxFit.cover),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imagetemporary = File(image.path);
      setState(() {
        images.add(createImage(imagetemporary));
        imagesPath.add(image.path);
      });
    } on Exception catch (e) {
      print(e.toString());
      showToast(context, e.toString());
    }
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

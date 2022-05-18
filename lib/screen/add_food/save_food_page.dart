import 'package:flutter/material.dart';

class SaveFoodPage extends StatelessWidget {
  const SaveFoodPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body:Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                hintText: 'Tìm món đã lưu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
       ),
    );
  }
}
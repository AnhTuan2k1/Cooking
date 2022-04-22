
import 'package:flutter/material.dart';

Future<void> showAlertDialog({required BuildContext context, required String content}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Bị thiếu dữ liệu rồi bạn ơi 🤧'),
        content: SingleChildScrollView(
          child: Text(content)
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dạ', style: TextStyle(fontSize: 17),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
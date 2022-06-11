
import 'package:flutter/material.dart';

Future<bool?> showAlertDeleteFoodDialog({required BuildContext context}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Xác nhận xóa món ăn này? 🤧'),
        actions: <Widget>[
          TextButton(
            child: const Text('Không', style: TextStyle(fontSize: 17),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Có', style: TextStyle(fontSize: 17),),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
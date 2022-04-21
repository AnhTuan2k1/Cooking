


import 'package:flutter/material.dart';

class Dropbtn extends StatefulWidget {
  const Dropbtn({Key? key}) : super(key: key);

  @override
  State<Dropbtn> createState() => _DropbtnState();
}

class _DropbtnState extends State<Dropbtn> {
  int dropdownValue = 2;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      elevation: 16,
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = newValue ?? dropdownValue;
        });
      },
      items: <int>[1, 2, 3, 4, 5, 6, 7].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            '${value.toString()} người',
            style: TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}

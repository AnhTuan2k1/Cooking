


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

class DropbtnLogout extends StatefulWidget {
  const DropbtnLogout({Key? key}) : super(key: key);

  @override
  State<DropbtnLogout> createState() => _DropbtnLogoutState();
}

class _DropbtnLogoutState extends State<DropbtnLogout> {
  String dropdownValue = 'log out';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue ?? dropdownValue;
        });
      },
      items: <String>['log out'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}

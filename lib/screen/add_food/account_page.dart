import 'package:cooking/screen/add_food/add_food_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: Center(
                child: ElevatedButton(
                  child: Text('Món mới'),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFoodPage())),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

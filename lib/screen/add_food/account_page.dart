import 'package:cooking/screen/add_food/add_food_page.dart';
import 'package:flutter/material.dart';
import 'myfood_page.dart';
import 'save_food_page.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';


class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(urlDragonAvatar)
              
            ),
            title: Text(
              'Đông Phong',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFoodPage()));
               
                  },
                    child: Text(
                      'Món mới',
                       style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                      )
                     
                   ),
                ),
              ),
            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Món đã lưu',),
                Tab(text: 'Món của tôi')

              ],
            ),
          ),
          body: TabBarView(
            children: [
              SaveFoodPage(),
              MyFoodPage()

            ],
          ),
        ),
      ),
      
    );
  }
}

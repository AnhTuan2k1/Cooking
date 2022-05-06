import 'package:cooking/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'background_image.dart';

class LoginWithGGPage extends StatefulWidget {
  const LoginWithGGPage({ Key? key }) : super(key: key);

  @override
  State<LoginWithGGPage> createState() => _LoginWithGGPageState();
}

class _LoginWithGGPageState extends State<LoginWithGGPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackgroundImage(),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text('Chào mừng đến', style: TextStyle(
                color: Colors.black,
                fontSize:  20,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Image(
               height: 90,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/logo.png'),
            ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.googleLogin();
                  },
                  child: Text(
                    "Đăng nhập bằng Google",
                     style: TextStyle(color: Colors.black,),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                ),  
              ),
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/gmail.jpg',
                    height: 22,
                    width: 22,
                  ),
                )
              ],
            ),
          TextButton(
            child: Text(
              "Đăng nhập với email",
              style: TextStyle(
                color: Colors.black,
              ),
              ),
            onPressed:() {} ,
          )
        ],
        ),
      ),
      
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Lựa chọn khác", 
               style: TextStyle(
                 color: Colors.black,
                 fontWeight: FontWeight.w600,
                 ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
          child: Divider(
            color: Colors.black,
            height: 1.5,
          ),
        );
  }
}
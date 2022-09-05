import 'dart:async';
import 'package:chat_app/Layout/Home.dart';
import 'package:chat_app/shared/components.dart';
import 'package:flutter/material.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(microseconds: 3000),()=>navigateAndFinish(context,Home()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const[
            Image(
              image: AssetImage('assests/images/logo.png')
              ,fit: BoxFit.cover,
            ),
             Text('Chats' , style: TextStyle(fontSize: 40),
             ),
            ],
          ),
        ),
    );
  }
}

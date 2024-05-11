import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
class Welcome extends StatefulWidget {

  

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SafeArea(
        child: Center(
          
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Text("Ecosync",style: text_style(size: 20),),
             SizedBox(height: 20,),
             
              Text("Hi, welcome!",style: text_style(size: 20),),
              SizedBox(height: 50,),
              button(background_color: Colors.white,context: context,text: "Log In",text_color: Colors.black,function: (){
               return Get.toNamed('/login');
              }),
              button(background_color: Colors.white,context: context,text: "Register",text_color: Colors.black,function: (){
               return Get.toNamed('/register');
              }),
            ],
          ),
        ),
      ),
      
    );
  }
}

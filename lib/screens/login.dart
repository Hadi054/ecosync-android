import 'dart:convert';
import 'package:ecosync/backend/backend.dart';
import 'package:http/http.dart' as http;

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
class Login extends StatefulWidget {

  

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool textvisible = true;
  final CounterController controller = Get.put(CounterController());
  late TextEditingController email = TextEditingController();
    late TextEditingController password = TextEditingController();
    


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SafeArea(
        child: Center(
          
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Text("Sign In",style: text_style(size: 20),),
             SizedBox(height: 20,),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child: TextField(
                    controller: email,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        label: Text(
                      'E-mail',
                      style: text_style(
                          size: 12,
                          text_color: Color.fromARGB(255, 135, 126, 127)),
                    )),
                  ),
             ),
              Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: TextField(
                    controller: password,
                    obscureText: textvisible,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (textvisible)
                                  textvisible = false;
                                else
                                  textvisible = true;
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Icon(
                              Icons.visibility,
                              size: 20,
                            ),
                          ),
                        ),
                        label: Text(
                          'Password',
                          style: text_style(
                            size: 12,
                            text_color: Color.fromARGB(255, 135, 126, 127),
                          ),
                        )),
                  ),
              ),
                              SizedBox(height: 50,),

              button(background_color: Color.fromARGB(255, 1, 136, 247),context: context,text: "Log In",text_color: Colors.white,radius: 2.00,height: .06,function: ()async {
                try {
                          final userCredential = await login(
                              email: email.text, password: password.text);
                          final user = userCredential.user;

                          if (user != null) {
                            Get.toNamed("/home");
                          }
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Text("Log in Failed",
                                      style: text_style(size: 25)),
                                ),
                              );
                            },
                          );
                        }
              }),
              button(background_color: Colors.white,context: context,text: "Reset Password",text_color: Colors.black,radius: 2.00,height: .06),
            ],
          ),
        ),
      ),
      
    );
  }
}

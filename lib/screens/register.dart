import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../backend/backend.dart';
class Register extends StatefulWidget {

  

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool textvisible1 = true;
  bool textvisible2 = true;
  final CounterController controller = Get.put(CounterController());
  late TextEditingController email = TextEditingController();
    late TextEditingController password = TextEditingController();
     late TextEditingController confirmpassword = TextEditingController();
   


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SafeArea(
        child: Center(
          
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Text("Register",style: text_style(size: 20),),
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
                    obscureText: textvisible1,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (textvisible1)
                                  textvisible1 = false;
                                else
                                  textvisible1 = true;
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
               Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: TextField(
                    controller: confirmpassword,
                    obscureText: textvisible2,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (textvisible2)
                                  textvisible2 = false;
                                else
                                  textvisible2 = true;
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
                          'Confirm Password',
                          style: text_style(
                            size: 12,
                            text_color: Color.fromARGB(255, 135, 126, 127),
                          ),
                        )),
                  ),
              ),
                              SizedBox(height: 50,),

              button(background_color: Color.fromARGB(255, 1, 136, 247),context: context,text: "Register",text_color: Colors.white,radius: 2.00,height: .06,function: ()async {
                if(confirmpassword.text!=password.text)
                  {
                    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Color.fromARGB(255, 28, 23, 43),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                
                Text(
                  "Your Passwords Do Not Match",
                  style: TextStyle(color: Colors.white),
                ),
              ]),
            ),
          );
        });
        return;
                  }
                
                await createuser(
                              email: email.text, password: password.text);
                Get.toNamed('/login');

               
              }),
              // button(background_color: Colors.white,context: context,text: "Reset Password",text_color: Colors.black,radius: 2.00,height: .06),
            ],
          ),
        ),
      ),
      
    );
  }
}

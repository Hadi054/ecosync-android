import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/backend/location.dart';
import 'package:ecosync/backend/upload.dart';
import 'package:http/http.dart' as http;

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../backend/backend.dart';
class Report extends StatefulWidget {

  

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool textvisible1 = true;
  bool textvisible2 = true;
  final CounterController controller = Get.put(CounterController());
  late TextEditingController issue = TextEditingController();
    late TextEditingController description = TextEditingController();

    late TextEditingController password = TextEditingController();
     late TextEditingController confirmpassword = TextEditingController();
  late TextEditingController location = TextEditingController();
    File? selectedImage ;
FirebaseFirestore firestore = FirebaseFirestore.instance;
 bool isChecked = false;
void locationState(locationController, address, district) {
    setState(() {
      locationController.text = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    
  Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }
    return Scaffold(appBar: appbar(context, "Report Issues"),
      
      body: SafeArea(
        child: Center(
          
          child: ListView(
            reverse: true,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:100.0),
                child: button(background_color: Color.fromARGB(255, 1, 136, 247),context: context,text: "Submit",text_color: Colors.white,radius: 2.00,height: .06,function: ()async {
                  var downloadurl;
                    if (selectedImage != null) {
                      var uploadtask = await upload(image: selectedImage);
                      downloadurl =
                          await (await uploadtask).ref.getDownloadURL();
                    }
                    DocumentReference documentReference =
                          await firestore.collection('report').add({
                        
                        'Location': location.text,
                        
                        'Description': description.text,
                        
                        'email': (isChecked)?null:auth.currentUser!.email,
                        'image': (downloadurl),
                        
                      });

                    Get.toNamed('/home');
                 
                }),
              ),
             SizedBox(height: 50,),
              ElevatedButton(
              onPressed: () async {
                File file = await pickImage();
                setState(() {
                  selectedImage = file;
                });
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Image',
                      style: text_style(),
                    ),
                  ]),
            ),
            (selectedImage == null )
                ? Container()
                : (selectedImage != null)
                    ? Container(
                        height: MediaQuery.of(context).size.height * .2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: (selectedImage != null)
                              ? Image.file(
                                  selectedImage!,
                                  fit: BoxFit.fitWidth,
                                )
                              : null,
                        ),
                      )
                    :  Container(),             SizedBox(height: 20,),

             Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child: TextField(keyboardType: TextInputType.multiline,
               maxLines: null,
                    controller: description,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        label: Text(
                      'Description',
                      style: text_style(
                          size: 12,
                          text_color: Color.fromARGB(255, 135, 126, 127)),
                    )),
                  ),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child: TextField(
                    controller: issue,
                    style: text_style(
                        size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                    decoration: InputDecoration(
                        label: Text(
                      'Type of  Issue',
                      style: text_style(
                          size: 12,
                          text_color: Color.fromARGB(255, 135, 126, 127)),
                    )),
                  ),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child:  textField(
                  keyboardtype: TextInputType.text,
                  suffixicon: getLocation(
                      context: context,
                      textEditingController: location,
                      textState: locationState),
                  textEditingController: location,
                  text: "Address",
                  ),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,0,8,8),
               child: Row(children: [
                Text("Do you want to be anonymous?",style: text_style(),),
                Checkbox(
                     checkColor: Colors.white,
                     fillColor: MaterialStateProperty.resolveWith(getColor),
                     value: isChecked,
                     onChanged: (bool? value) {
                       setState(() {
                         isChecked = value!;
                       });
                     },
                   )
               ],),
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,100,8,8),
               child: Text("Report Issues",style: text_style(size: 20),),
             ),
             
             
              
                   

               // button(background_color: Colors.white,context: context,text: "Reset Password",text_color: Colors.black,radius: 2.00,height: .06),
            ],
          ),
        ),
      ),
      
    );
  }
}

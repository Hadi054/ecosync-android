// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/backend/upload.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';

import '../backend/backend.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class Articles extends StatefulWidget {
   Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles>
    with SingleTickerProviderStateMixin {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

   late TextEditingController description = TextEditingController();
   File? selectedImage ;
  @override
  void initState() {
    super.initState();
  }
 Future<String?> screenshot() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }
    ScreenshotController screenshotController = ScreenshotController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,"Articles"),  body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('articles')
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData) {
            List<DocumentSnapshot> documents = snap.data!.docs;
            return Container(height: MediaQuery.of(context).size.height*.9,
              child: ListView(
                  children: documents.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Screenshot(controller: screenshotController,
                        child: Container(height: MediaQuery.of(context).size.height*.5,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['email'],
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              doc['Description'],
                              style: text_style(),
                            ),
                             SizedBox(
                              height: 10,
                            ),
                            Container(height: MediaQuery.of(context).size.height*.3,
                          child: (doc['image']!=null)?ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: (
                                 Image.network(
                                    doc['image'],
                                    fit: BoxFit.scaleDown,
                                  )
                                
                          ),):Container()
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(height: MediaQuery.of(context).size.height*.09,
                          
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              IconButton(onPressed: ()async{
                              SocialShare.copyToClipboard(image: await screenshot(),).then((data) {
                              print(data);
                            });
                            }, icon: Icon(Icons.link),iconSize: 30,),
                             IconButton(onPressed: ()async{
                              SocialShare.shareFacebookStory(imagePath: await screenshot(),appId: '1489631191904252').then((data) {
                              print(data);
                            });
                            }, icon: Icon(Icons.facebook),iconSize: 30,),
                            IconButton(onPressed: ()async{
                              SocialShare.shareInstagramStory(imagePath: await screenshot()??"",appId: '1489631191904252').then((data) {
                              print(data);
                            });
                            }, icon: FaIcon(FontAwesomeIcons.instagram),iconSize: 30,),
                            ],),),
                            
                        )
                       ],
                        ),
                                        ),
                      ),
                    );
                     
                        
                  }).toList(),
                ),
            )
            ;
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
        }), ),),
 floatingActionButton: FloatingActionButton(onPressed: (){
  showDialog(
      context: context,
      builder: (BuildContext context) {

        return Dialog(
          child: Container(height: MediaQuery.of(context).size.width*.7,
            child: Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child: ListView(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(keyboardType:TextInputType.multiline,maxLines: null,controller: description,
                          style: text_style(
                              size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                          decoration: InputDecoration(
                              label: Text(
                            'Write what\'s on your mind?',
                            style: text_style(
                                size: 12,
                                text_color: Color.fromARGB(255, 135, 126, 127)),
                          )),
                        ),
                   ),
                     ElevatedButton(
              onPressed: () async {
                File file = await pickImage();
                setState(() {
                  selectedImage = file;
                });
                print(file);
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
                    :  Container(),
                     button(background_color: Colors.white,context: context,text: "Submit",text_color: Colors.black,radius: 2.00,height: .06,function: () async {
                     var downloadurl;
                    if (selectedImage != null) {
                      var uploadtask = await upload(image: selectedImage);
                      downloadurl =
                          await (await uploadtask).ref.getDownloadURL();
                    }
                      DocumentReference documentReference =
                          await firestore.collection('articles').add({                 
                        'Description': description.text,              
                        'email': auth.currentUser!.email,
                        'datetime':Timestamp.now(),
                        'image':downloadurl
                      });
                                            Navigator.of(context).pop();

                     }),

                 ],
               ),
             ),
          ),
          insetAnimationCurve: Curves.bounceIn,
        );
      });
 },child: Icon(Icons.add),),
    );
  }
}


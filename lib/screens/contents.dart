import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/backend/upload.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../backend/backend.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class Contents extends StatefulWidget {
  const Contents({super.key});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;

    ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,"Articles"),floatingActionButton: FloatingActionButton(onPressed: (){Get.toNamed('/post');
},child: Icon(Icons.add),),
body: Container(height: MediaQuery.of(context).size.height*.9,child: 
StreamBuilder<QuerySnapshot>(
  stream:firestore
            .collection('articles')
            .snapshots(),
  builder: (context, snapshot) {
    if(snapshot.hasData)
    {List<DocumentSnapshot> documents = snapshot.data!.docs;
      return ListView(children:documents.map((e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(alignment: Alignment.centerLeft,
            color: Colors.grey[100],child: Column(children: [Text(e['email'],style: text_style(weight: FontWeight.bold),),SizedBox(height: 1,child: Container(color: Colors.black,),),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(e['Description'],style: text_style(size: 20),textAlign: TextAlign.start,),
          ),Container(height: MediaQuery.of(context).size.height*.4,
            child: Image.network(e['image'],fit: BoxFit.fitHeight,)),Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  ],),
                          ],),),
        );
      },) .toList()
      ,);
 }else return Container() ;}
)
),
    );

  }
}
class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

   late TextEditingController description = TextEditingController();
   File? selectedImage ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context,"Post Article"),
      body: Container(alignment: Alignment.center,
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
          ),);
  }
}
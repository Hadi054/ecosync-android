// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/backend/location.dart';
import 'package:ecosync/backend/upload.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../backend/backend.dart';
class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum>
    with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
   late TextEditingController description = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,"Forum"),  body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('forum')
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData) {
            List<DocumentSnapshot> documents = snap.data!.docs;
            return Container(
              height: MediaQuery.of(context).size.height * .55,
              child: ListView(
                children: documents.map((doc) {
                  return GestureDetector(
                    onTap: (){
                      showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          surfaceTintColor: main_color_light,
          backgroundColor: main_color_light.withOpacity(1),
          insetPadding: EdgeInsets.zero,
          child: FullPost(doc),
          insetAnimationCurve: Curves.bounceIn,
        );
      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                          DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                           
                            Text('Reply'),
                          ],
                        ),
                      ),
                                      )
                        ],
                      ),
                                      ),
                    ),
                  );
       
                      
                }).toList(),
              ),
            );
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
                     button(background_color: Colors.white,context: context,text: "Submit",text_color: Colors.black,radius: 2.00,height: .06,function: () async {
                      DocumentReference documentReference =
                          await firestore.collection('forum').add({                 
                        'Description': description.text,              
                        'email': auth.currentUser!.email,
                        'datetime':Timestamp.now(),
                        
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

class FullPost extends StatefulWidget {
  dynamic doc;

   FullPost(this.doc);

  @override
  State<FullPost> createState() => _FullPostState();
}

class _FullPostState extends State<FullPost> {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
   late TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
            .collection('comment').snapshots(),
          builder: (context, snapshot) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;

            return CommentTreeWidget<Comment, Comment>(
              Comment(
                  avatar: 'null',
                  userName: widget.doc['email'],
                  content: widget.doc['Description']),
              documents.map((e) => Comment(
                  avatar: 'null',
                  userName: 'null',
                  content: e['comment'])).toList(),
             treeThemeData:
                  TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 3),
              avatarRoot: (context, data) => PreferredSize(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/avatar_2.png'),
                ),
                preferredSize: Size.fromRadius(18),
              ),
              avatarChild: (context, data) => PreferredSize(
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/avatar_1.png'),
                ),
                preferredSize: Size.fromRadius(12),
              ),
              contentChild: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'tareque@gmail.com',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${data.content}',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w300, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text('Report'),
                            SizedBox(
                              width: 24,
                            ),
                            
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
              contentRoot: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doc['email'],
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${data.content}',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.w300, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text('Report'),
                            SizedBox(
                              width: 24,
                            ),
                            GestureDetector(onTap: (){
                              showDialog(
                  context: context,
                  builder: (BuildContext context) {
            return Dialog(
              child: Container(height: MediaQuery.of(context).size.width*.6,
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
                                'Reply',
                                style: text_style(
                                    size: 12,
                                    text_color: Color.fromARGB(255, 135, 126, 127)),
                              )),
                            ),
                       ),
                         button(background_color: Colors.white,context: context,text: "Submit Reply",text_color: Colors.black,radius: 2.00,height: .06,function: () async {
                     
            
                              await firestore.collection('comment').add({  
                                'docid'   :widget.doc.id,
                                'email'   :auth.currentUser!.email,         
                            'comment':description.text ,              
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
            
                          
                            },
                              child: Text('Reply')),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        ),
      );
    

  }
}
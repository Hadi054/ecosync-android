import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosync/backend/upload.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ecosync/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ecosync/backend/backend.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,"Events"),floatingActionButton:  FloatingActionButton(onPressed: (){Get.toNamed('/postevent');
},child: Icon(Icons.add),),body: Container(color: Colors.grey[100],height: MediaQuery.of(context).size.height*.9,child: StreamBuilder<QuerySnapshot>(
  stream:firestore
            .collection('events')
            .snapshots(),
  builder: (context, snapshot) {
    if(snapshot.hasData)
    {List<DocumentSnapshot> documents = snapshot.data!.docs;
      return ListView(children:documents.map((e) {
         DateFormat format = DateFormat('MMMM d, yyyy, hh:mm a');
  var event_datetime = format.format(e['event_datetime'].toDate());
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.teal[100],child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Event Creator: "+e['email'],style: text_style(weight: FontWeight.bold),),SizedBox(height: 20,),Text("Event Title: "+e['title'],style: text_style(size: 15)),
                SizedBox(height: 20,),Text("Event Start: "+event_datetime.toString(),style: text_style(size: 15),),
                        
              
                            ],),
            ),),
        );
      },) .toList()
      ,);
 }else return Container() ;}
)
,),

    );
  }
}
class PostEvent extends StatefulWidget {
  const PostEvent({super.key});

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  DateTime? startDate;
    TimeOfDay? starttime;
FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController edate = TextEditingController();
TextEditingController etime = TextEditingController();
TextEditingController title = TextEditingController();
TextEditingController topic = TextEditingController();
  void calenderState(dateController) async {
    DateTime? sel = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime(2099, 12, 31),
    );
    setState(() {
      if (sel != null) {
        startDate = sel;
        DateFormat format = DateFormat('MMMM d,yyyy');
        dateController.text = format.format(sel);
      }
    });
  }
  void timeState(timeController) async {
    TimeOfDay? sel = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        useRootNavigator: false);
    setState(() {
      if (sel != null) {
        starttime = sel;
        DateFormat format = DateFormat('hh:mm a');
        timeController.text =
            format.format(DateTime(2000, 01, 01, sel.hour, sel.minute));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context,"Post Events"),
      body: Container(alignment: Alignment.center,
            child: Padding(
               padding: const EdgeInsets.fromLTRB(20,0,20,0),
               child: ListView(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(keyboardType:TextInputType.multiline,maxLines: null,controller: title,
                          style: text_style(
                              size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                          decoration: InputDecoration(
                              label: Text(
                            'Event Title',
                            style: text_style(
                                size: 12,
                                text_color: Color.fromARGB(255, 135, 126, 127)),
                          )),
                        ),
                   ),
                                      Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(keyboardType:TextInputType.multiline,maxLines: null,controller: topic,
                          style: text_style(
                              size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
                          decoration: InputDecoration(
                              label: Text(
                            'Event Description',
                            style: text_style(
                                size: 12,
                                text_color: Color.fromARGB(255, 135, 126, 127)),
                          )),
                        ),
                   ),
                time(
                timeController: etime,
                timeState: timeState,
                timeText: "Event Time"),
            SizedBox(height: 20),
            calender(
                calenderState: calenderState,
                calenderText: 'Event Date',
                dateController: edate),

                      button(background_color: Colors.white,context: context,text: "Submit",text_color: Colors.black,radius: 2.00,height: .06,function: () async {
                     var downloadurl;
                    Timestamp timestamp = Timestamp.now();
                      if (startDate != null && starttime != null) {
                        timestamp = Timestamp.fromDate(DateTime(
                            startDate!.year,
                            startDate!.month,
                            startDate!.day,
                            starttime!.hour,
                            starttime!.minute));
                      }
                      DocumentReference documentReference =
                          await firestore.collection('events').add({                 
                       'title':title.text,
                       'topic':topic.text,
                       'event_datetime':timestamp,
                       'email':auth.currentUser!.email
                      });
                                            Navigator.of(context).pop();

                     }),

          

                 ],
               ),
             ),
          ),);
;
  }
}
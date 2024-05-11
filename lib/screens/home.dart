import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../constants.dart';
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,"Home") ,
        body: SafeArea(child: GridView.count(
  primary: false,
  padding: const EdgeInsets.all(20),
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  crossAxisCount: 3,
  children: <Widget>[
    GestureDetector(onTap: (){
      Get.toNamed('/report');
    },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.teal[100],),
        alignment: Alignment.center,
        child:  Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
        HeroIcons.flag,
        style: HeroIconStyle.outline, // Outlined icons are used by default.
        color: Colors.black,
        size: 30,
      ),
            Text("Report",style: text_style(size: 18,text_color: Colors.black),),
          ],
        ),
      ),
    ),
    GestureDetector(
      onTap: (){
        Get.toNamed('/forum');
      },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.teal[200],),
        alignment: Alignment.center,
        child:  Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
        HeroIcons.chatBubbleLeftRight,
        style: HeroIconStyle.outline, // Outlined icons are used by default.
        color: Colors.black,
        size: 30,
      ),
            Text("Forum",style: text_style(size: 18,text_color: Colors.black),),
          ],
        ),
      ),
    ),
    GestureDetector(
      onTap: (){
        Get.toNamed('/articles');
      },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.teal[300],),
        alignment: Alignment.center,
        child:  Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
        HeroIcons.clipboardDocumentList,
        style: HeroIconStyle.outline, // Outlined icons are used by default.
        color: Colors.black,
        size: 30,
      ),
            Text("Articles",style: text_style(size: 18,text_color: Colors.black),),
          ],
        ),
      ),
    ),
   GestureDetector(
      onTap: (){
        Get.toNamed('/calander');
      },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.teal[400],),
        alignment: Alignment.center,
        child:  Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
        HeroIcons.calendar,
        style: HeroIconStyle.outline, // Outlined icons are used by default.
        color: Colors.white,
        size: 30,
      ),
            Text("Event Calander",style: text_style(size: 18,text_color: Colors.white),textAlign: TextAlign.center,),
          ],
        ),
      ),
    ),
  GestureDetector(
      onTap: (){
        Get.toNamed('/event');
      },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.teal[500],),
        alignment: Alignment.center,
        child:  Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event,color: Colors.white,size: 30,),
            Text("Events",style: text_style(size: 18,text_color: Colors.white),textAlign: TextAlign.center,),
          ],
        ),
      ),
    ),
  
     
      ],
)
      ),
    );
  }
}
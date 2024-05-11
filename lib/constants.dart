// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecosync/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Color main_color = Color.fromARGB(255, 220, 26, 71);
Color main_color_light = Color.fromARGB(200, 242, 230, 225);

Color text_color = Color.fromARGB(255, 135, 126, 127);
Color title_color = Color.fromARGB(255, 73, 0, 8);
TextStyle text_style(
    {Color? text_color, double? size, FontWeight? weight = FontWeight.normal}) {
  return TextStyle(
      color: text_color,
      fontSize: size,
      fontWeight: weight,
      fontFamily: 'Lexend');
}

TextButton button(
    {text,height =.07,radius=50.0,
    context,
    background_color,
    text_color,
    function,
    double? text_size}) {
  return TextButton(
      onPressed: function,
      child: Container(
        height: MediaQuery.of(context).size.height * height,
        width: MediaQuery.of(context).size.width * .7,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(199, 188, 184, 184),
                offset: const Offset(
                  0.0,
                  3.0,
                ),
                blurRadius: 5.0,
                //spreadRadius: 2.0,
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: background_color),
        child: Center(
            child: Text(text,
                style: text_style(text_color: text_color, size: text_size))),
      ));
}

Widget label(IconData? icon, String text) {
  return Row(
    children: [
      
      Text(
        text,
        style: text_style(
            size: 12, text_color: Color.fromARGB(255, 135, 126, 127)),
      ),
    ],
  );
}

Widget textField(
    {textEditingController, icon, text, suffixicon, keyboardtype}) {
  return TextFormField(
    keyboardType: keyboardtype,
    controller: textEditingController,
    style: text_style(size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
    decoration:
        InputDecoration(label: label(icon, text), suffixIcon: suffixicon),
  );
}

Widget passwordField(
    {textVisible, textVisibleState, labelText, paswordcontroller}) {
  return TextFormField(
    controller: paswordcontroller,
    obscureText: textVisible,
    style: text_style(size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
    decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () => textVisibleState(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Icon(
              Icons.visibility,
              size: 20,
            ),
          ),
        ),
        label: label(Icons.lock, labelText)),
  );
}

Widget calender({dateController, calenderState, calenderText}) {
  return TextFormField(
    readOnly: true,
    controller: dateController,
    keyboardType: TextInputType.datetime,
    onTap: () async {
      calenderState(dateController);
    },
    style: text_style(size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
    decoration:
        InputDecoration(label: label(Icons.calendar_month, calenderText)),
  );
}

Widget time({timeController, timeState, timeText}) {
  return TextFormField(
    readOnly: true,
    controller: timeController,
    keyboardType: TextInputType.datetime,
    onTap: () async {
      timeState(timeController);
    },
    style: text_style(size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
    decoration: InputDecoration(label: label(Icons.alarm_on, timeText)),
  );
}

List<DropdownMenuItem> dropDownItemBuilder(List<String> list) {
  List<DropdownMenuItem> menuItems = [];
  for (int i = 0; i < list.length; i++) {
    menuItems.add(DropdownMenuItem(value: list[i], child: Text(list[i])));
  }
  return menuItems;
}

Widget dropDown({list, labelText, labelIcon, onValueChanged, value}) {
  return DropdownButtonFormField(
      value: value,
      decoration: InputDecoration(label: label(labelIcon, labelText)),
      items: dropDownItemBuilder(list),
      onChanged: onValueChanged,
      style: text_style(size: 16, text_color: Color.fromARGB(255, 25, 24, 24)),
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Icon(
            Icons.arrow_drop_down,
            size: 25,
          ),
        ),
      ));
}

AppBar appbar(context,title){
  return AppBar(
    toolbarHeight: MediaQuery.of(context).size.height * .1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
      ),
    ),
    actions: [
      IconButton(
          onPressed: () {
          },
          icon: Icon(
            size: 30,
            Icons.settings,
            color:
                Color.fromARGB(255, 5, 242, 250),
          ))
          ,
          IconButton(
          onPressed: () {
            logOut();
            Get.toNamed('/');
          },
          icon: Icon(
            size: 30,
            Icons.logout,
            color:
                Color.fromARGB(255, 5, 242, 250),
          ))
    ],
    backgroundColor: Colors.blue,
    title: Text(
      title,
      style: text_style(size: 30, text_color: Colors.white),
    ),
  );

}
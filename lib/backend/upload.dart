import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

Future<File> pickImage() async {
  ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) {
    throw Exception('Image picking canceled');
  }
  final originalFile = File(image.path);
  const int targetWidth = 256 * 2;
  const int targetQuality = 256;
  final originalImage = img.decodeImage(originalFile.readAsBytesSync())!;
  final resizedImage = img.copyResize(originalImage, width: targetWidth);
  final compressedBytes = img.encodeJpg(resizedImage, quality: targetQuality);
  final compressedFile = await originalFile.writeAsBytes(compressedBytes);

  return compressedFile;
}
Future<File> pickVideo() async {
  ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickVideo(source: ImageSource.gallery);
  if (image == null) {
    throw Exception('Image picking canceled');
  }
  final originalFile = File(image.path);
  

  return originalFile;
}
Future<dynamic> upload({image}) async {
  var uploadtask = await firebase_storage.FirebaseStorage.instance
      .ref('uploads/${image.path}')
      .putFile(image);
  return uploadtask;
}
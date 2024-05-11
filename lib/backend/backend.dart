import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

final auth = FirebaseAuth.instance;
Future createuser({email, password}) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    return userCredential;
  } catch (e) {
    // Handle user creation errors
    throw e;
  }
}
Future<UserCredential> login({email, password}) async {
  try {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    return userCredential;
  } catch (e) {
    throw e;
  }
}
Future<void> logOut() async {
  await FirebaseAuth.instance.signOut();
}
User? getuser() {
  return auth.currentUser;
}
import 'package:ecosync/backend/backend.dart';
import 'package:ecosync/screens/home.dart';
import 'package:ecosync/screens/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/welcome.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
User? loggedInUser;

  initState() {
    setState(() {
      loggedInUser = getuser();
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: routes,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  (loggedInUser==null)?Welcome():Home(),
    );        
}
}



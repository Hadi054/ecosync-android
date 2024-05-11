import 'package:ecosync/screens/calander.dart';
import 'package:ecosync/screens/contents.dart';
import 'package:ecosync/screens/events.dart';
import 'package:ecosync/screens/forum.dart';
import 'package:ecosync/screens/home.dart';

import 'screens/welcome.dart';
import 'screens/login.dart';
import 'package:get/get.dart';
import 'screens/register.dart';
import 'screens/report.dart';
// import 'screens/articles.dart';
final routes = [
  GetPage(name: '/', page: () => Welcome()),
  GetPage(name: '/login', page: () => Login()),
  GetPage(name: '/report', page: () => Report()),
  GetPage(name: '/register', page: () => Register()),
  GetPage(name: '/home', page: () => Home()),
    GetPage(name: '/forum', page: () => Forum()),
        GetPage(name: '/articles', page: () => Contents()),
         GetPage(name: '/post', page: () => Post()),
         GetPage(name: '/calander', page: () => Calander()),
         GetPage(name: '/event', page: () => Event()),
         GetPage(name: '/postevent', page: () => PostEvent()),


];
import 'package:get/get.dart';

class CounterController extends GetxController{
  final count = 0.obs;
  void increment (){
    print(count.value);
    count.value++;
  }
}

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ocrapp/Controller/FolderController.dart';
import 'package:ocrapp/Controller/ServerController.dart';

class defaultBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ServerController>(ServerController());
    Get.put<FolderController>(FolderController());

    // Get.lazyPut(()=>ItemController(),fenix: true);
    // Get.put(customerController());
    // Get.lazyPut(()=>LoginController());
  }

}
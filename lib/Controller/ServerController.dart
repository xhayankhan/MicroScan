import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocrapp/Constants/Constants.dart';
import 'package:ocrapp/Views/HomePage.dart';
import 'package:ocrapp/Views/TextEditingScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AdsController/GettingAdds.dart';
import '../Views/LoadingPage.dart';

class ServerController extends GetxController{
  File? outFile;
  var responseString;
  TextEditingController rename=TextEditingController();
  TextEditingController ocrText=TextEditingController();
QuillController controller = QuillController.basic();
  CroppedFile? _croppedFile;
  RxList savedFiles=[].obs;
  RxInt screenCount=0.obs;
List response=[];
var context;


  Future ReadJsonData(File img) async {
    final applicationBloc = Provider.of<get_ads>(context,listen: false);
    applicationBloc.createInterstitialScanAd();
    applicationBloc.showInterstitialScanAd();
    Get.off(()=>LoadingPage());

    final String ApiUrl2 =
        "http://117.20.29.108:5500/upload_file";
    print(ApiUrl2);

    var request = http.MultipartRequest("POST", Uri.parse(ApiUrl2));
    // request.fields['factor'] = factor;
    // print(factor);
    request.files.add(await http.MultipartFile.fromPath('img', img.path));


    request.headers.addAll({'Content-type': 'multipart/formdata'});
    print('Sending request...');

    try {
      var res = await request.send().timeout(const Duration(seconds: 40));

  var responseData = await res.stream.toBytes();

   responseString = String.fromCharCodes(responseData);

  Map valueMap = json.decode(responseString);
  var text = valueMap['0'].toString();
  ocrText.text = text;
  print(text);

  print(response);

  await makeController(ocrText.text);




}
catch(e){
      if(e.toString()=='Connection failed')
{
  Fluttertoast.showToast(
      msg: "No Internet, Please check your Internet connection",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
      else{
        Fluttertoast.showToast(
            msg: "Our Image to Text engine is currently under load, Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  Get.off(()=>HomePage());
  print('error is: $e');
}
    return responseString;
  }
textToFile(String text) async {
  Directory? directory = await getApplicationDocumentsDirectory();

  bool directoryExists =
  await Directory('${directory.path}/Documents').exists();

  if (!directoryExists) {
    print("\n Directory not exist");
    //  navigateToShowPage(path, -1);
    await Directory('${directory.path}/Documents').create(recursive: true);

    //Getting all images of chapter from firectory

  }

  print("\n direcctoryb = ${directory}");
  final fullPath =
      '${directory.path}/Documents/${DateTime
      .now()}';
  //final imgFile = File('$fullPath');
   outFile = File('$fullPath');
  outFile?.writeAsString(text);
  print(outFile?.path);
  //imgFile.writeAsBytesSync(imglib.encodePng(image));
  return outFile;
}
makeController(String text){
  Map toJson= {
    jsonEncode("insert"):jsonEncode("$text\n"),


  };



  response.add(toJson);
  print(response);
  var myJSON = jsonDecode(response.toString());
  controller = QuillController(
      document: Document.fromJson(myJSON),
      selection: TextSelection.collapsed(offset: 0));

  Get.off(()=>TextEditingScreen(),arguments: controller);

  response=[];
}
  Future launchUrl1(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> cropImage(File pickedFile, bool camera) async {
    if (pickedFile != null&&camera==false) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: darkBlue,
                backgroundColor: Colors.white,
              statusBarColor: Colors.black,
              //dimmedLayerColor: Colors.white,
              cropFrameColor: Colors.black,
              cropGridColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),

        ],
      );
      if (croppedFile != null) {

          _croppedFile = croppedFile;
          var file=File(_croppedFile!.path);
          var res =await ReadJsonData(file);

          print(res);
      }


    }
    else{
      var res =await ReadJsonData(pickedFile);
      print(res);
    }


  }
  permissionCheck() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera
    ].request();
    print('premission ststus ${statuses[Permission.storage]}');
    return statuses[Permission.storage];
  }
  void pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf']);

      if (result != null) {
        final picked = result.files;
        print(picked);
      } else {
        // User canceled the picker
      }

      //String filePath = file.path;

      //Get.to(()=>DocumentViewer(),arguments: filePath);

    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete(recursive: true);
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
  Future<void> deleteFolder(Directory dir) async {
    try {
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
  share(String path){
    Share.shareFiles(['${path}'], text: 'Courtesy of Micro Scan\nhttps://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

  }
  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}
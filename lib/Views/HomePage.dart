import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocrapp/Constants/Constants.dart';
import 'package:ocrapp/Controller/FolderController.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:ocrapp/Views/FolderView.dart';
import 'package:ocrapp/Widgets/GridViewOfGallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:image/image.dart' as imglib;

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Controller/ServerController.dart';
import '../Widgets/NavDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var pickedFile;
  File? image1;
  bool adshown=false;
  int countpic=0;
  int countcam=0;
  bool isPaused = false;

  bool pdf=false;
  ServerController server=Get.find();
  FolderController folder=Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  ImagePicker imagePicker = ImagePicker();
  @override
  void initState(){
    super.initState();
    createFolders();
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );



    WidgetsBinding.instance.addObserver(this);
    server.screenCount.value=1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print("didChangeAppLifecycleState called");
    print("adshown = ${adshown} , countpic = ${countpic} , countcam = ${countcam}");
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }

    if (state == AppLifecycleState.resumed && adshown&& isPaused&&countpic==1||countcam==1) {
      print("Resumed==========================");

      appOpenAdManager.showAdIfAvailable();
      // countpic=1;
      // countcam=1;
      isPaused = false;
      //adshown=false;
    }
  }

  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    applicationBloc.createInterstitialFileAd();
    applicationBloc.createInterstitialScanAd();
    applicationBloc.createInterstitialBackAd();
    appOpenAdManager.loadAd();
    await applicationBloc.creater_homePage_banner_ad();
    await applicationBloc.create_files_banner_ad();
    await applicationBloc.create_folder_banner_ad();
    await applicationBloc.creater_loading_banner_ad();
    await applicationBloc.create_fileView_banner_ad();
    await applicationBloc.create_select_banner_ad();
    await applicationBloc.create_textEdit_banner_ad();

  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);
    server.context=context;
    return Scaffold(
      drawer: NavDrawer(),

      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(children: [
                Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 7.h,
                    child: applicationBloc.is_homePage_banner_Ready == true
                        ? AdWidget(ad: applicationBloc.homePage_banner)
                        : Container()
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: 7.h,
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.yellow,
                    child: const Text(
                      "Ad",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]),
             Container(
               height: 9.h,
               decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                     colors: [
                       lightBlue,
                       darkBlue,
                     ],
                   )
               ),
               child: Center(
                 child: Padding(
                   padding: const EdgeInsets.only(left: 8.0,right: 8),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           InkWell(
                             onTap: (){
                               scaffoldKey.currentState?.openDrawer();
                             },
                             child: SvgPicture.asset('assets/menubar.svg'),

                           ),
                           Text('Import Picture',style: TextStyle(
                             fontSize: 25,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                           ),),
                           Padding(
                             padding: const EdgeInsets.only(right: 2.0),
                             child: InkWell(
                               onTap: (){
                                 applicationBloc.showInterstitialFileAd();
                                 Get.off(()=>const FilesandFolders());
                               },

                                   child:SvgPicture.asset('assets/file.svg'),

                             ),
                           ),
                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(width: 5,),
                           Text('Files',style: TextStyle(
                               color: Colors.white
                           ),),
                         ],
                       )
                     ],
                   ),
                 ),
               ),
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                     height: 70.h,

                     child:  GetBuilder<FolderController>(
                         init:FolderController(),
                         builder: (context) {return GridGallery();}
                     )
                 ),
               ),
             ),
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: darkBlue
                ),
                child: Center(
                  child: Padding(

                    padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: ()async{
                            adshown=true;
                            Future.delayed(const Duration(seconds: 2)).then((value) =>  countpic++);
                            var pickedFile = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 60,);
                            log('after picked');
                            if(pickedFile!=null){
                              image1 = File(pickedFile.path);
                              log(image1.toString());
                              await EasyLoading.show(status: 'Loading...',);
                              Uint8List uint8list = Uint8List.fromList(
                                  image1!.readAsBytesSync());
                              // String? imagePath = await EdgeDetection.detectEdge;
                              imglib.Image? image = imglib.decodeImage(uint8list);
                              await imgTofile(image!);
                              EasyLoading.dismiss();
                              var file= await server.cropImage(image1!,false);

                            }


                          },
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.white,),
                              Text('Gallery',style: TextStyle(
                                  color: Colors.white
                              ),),

                            ],
                          ),
                        ),
                        InkWell(
                          onTap:()async{
                            await server.permissionCheck();
                            // var version=11.0;
                            // var tr= await Permission.storage.isGranted;
                            // var tra= await Permission.storage.status.isGranted;
                            // if(Platform.isAndroid){
                            //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                            //   version=double.parse(androidInfo.version.release.toString());
                            //   print(version.runtimeType);
                            //   print("Android ${version} on ${androidInfo.model}"); // e.g. "Moto G (4)"
                            //   print(Platform.operatingSystem);
                            // }
                            //if(tr==true||version<11.0){
                              adshown=true;
                              Future.delayed(const Duration(seconds: 2)).then((value) =>  countcam++);
                              var pickedFile = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 40,);
                              if(pickedFile!=null){
                                var img=File(pickedFile.path);
                                await EasyLoading.show(status: 'Loading...',);
                                Uint8List uint8list = Uint8List.fromList(
                                    img.readAsBytesSync());

                                imglib.Image? image = imglib.decodeImage(uint8list);
                                await imgTofile(image!);
                                EasyLoading.dismiss();
                                var file= await server.cropImage(img,false);
                              }

                           // }
                           //  else{
                           //    Get.defaultDialog(
                           //        backgroundColor: dialogueColor,
                           //        title: 'Permission Required',
                           //        titleStyle: TextStyle(
                           //            color: darkBlue,
                           //            fontWeight: FontWeight.bold
                           //        ),
                           //        content: Padding(
                           //          padding: const EdgeInsets.all(8.0),
                           //          child: Column(
                           //            mainAxisAlignment: MainAxisAlignment.start,
                           //            crossAxisAlignment: CrossAxisAlignment.start,
                           //            children: [
                           //              Text('We need camera permission in order to take images from your Camera to get text from them',style: TextStyle(color: darkBlue),),
                           //              Text('Go to',style: TextStyle(color: darkBlue),),
                           //              Text('Settings>Apps>Micro Scanner>Permissions',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold,fontSize: 14),),
                           //              Text('and allow Camera Permission',style: TextStyle(color: darkBlue),),
                           //
                           //            ],
                           //          ),
                           //        ),
                           //        confirm: InkWell(
                           //          onTap: () async{
                           //            Navigator.pop(context);
                           //            PhotoManager.openSetting();
                           //          },
                           //          child: Container(
                           //            decoration: BoxDecoration(
                           //                color: darkBlue,
                           //                borderRadius: BorderRadius.circular(10)
                           //            ),
                           //            child: Container(
                           //              height: 30,
                           //              width: 80,
                           //              child: Center(
                           //                child: Text('Ok',style: TextStyle(color: Colors.white),),
                           //              ),
                           //            ),
                           //          ),
                           //        ),
                           //        cancel: InkWell(
                           //          onTap: (){
                           //            Navigator.pop(context);
                           //            Fluttertoast.showToast(
                           //                msg: "Camera permission was not allowed",
                           //                toastLength: Toast.LENGTH_LONG,
                           //                gravity: ToastGravity.BOTTOM,
                           //                timeInSecForIosWeb: 1,
                           //                backgroundColor: Colors.red,
                           //                textColor: Colors.white,
                           //                fontSize: 16.0
                           //            );
                           //          },
                           //          child: Container(
                           //            height: 30,
                           //            width: 80,
                           //            decoration: BoxDecoration(
                           //
                           //                borderRadius: BorderRadius.circular(10),
                           //                border: Border.all(color: darkBlue,width: 1)
                           //
                           //            ),
                           //            child: Center(child: Text('Cancel',style: TextStyle(color: darkBlue),)),
                           //          ),
                           //        )
                           //    );
                           //
                           //  }
                          },





                          child: Column(
                            children: [
                              Icon(Icons.camera_alt,color: Colors.white,),
                              Text('Camera',style: TextStyle(
                                  color: Colors.white
                              ),),

                            ],
                          ),
                        ),
                        InkWell(
                          onTap:() async{
                            var appDir=await getApplicationDocumentsDirectory();
                            var dir2='${appDir.path}/Documents/Folders/Recents';


                            Get.off(()=>FolderView(),arguments: dir2);

                          },
                          child: Column(
                            children: [
                              Icon(Icons.home_filled,color: Colors.white,),
                              Text('Recents',style: TextStyle(
                                  color: Colors.white
                              ),),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  imgTofile(imglib.Image image) async {

    Directory? directory = await getApplicationDocumentsDirectory();

    bool directoryExists =
    await Directory('${directory.path}/Pictures/Saved').exists();

    if (!directoryExists) {
      print("\n Directory not exist");
      //  navigateToShowPage(path, -1);
      await Directory("${directory.path}/Documents/Folders/Recents").create(recursive: true);

      //Getting all images of chapter from firectory

    }

    print("\n direcctoryb = ${directory}");
    final fullPath =
        '${directory.path}/Documents/Folders/Recents/MS ${DateTime
        .now()}.png';
    final imgFile = File('$fullPath');
    log(imgFile.path);
    imgFile.writeAsBytesSync(imglib.encodePng(image));
    return imgFile;

  }
  createFolders() async{
    var appDir=await getApplicationDocumentsDirectory();
    var dirFolder=Directory('${appDir.path}/Documents/Folders/');
    var foldersPath='${appDir.path}/Documents/Folders/';
    await Directory('${foldersPath}').create(recursive: true);
    // var b= await Directory('${foldersPath}/New Folder').create(recursive: true);
    var c=await Directory('${foldersPath}/Saved').create(recursive: true);
    var a= await Directory('${foldersPath}/Recents').create(recursive: true);
    // log(b.path);
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:ocrapp/Views/FolderView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Constants/Constants.dart';
import '../Controller/ServerController.dart';

class SavedFilesPreview extends StatefulWidget {
  const SavedFilesPreview({Key? key}) : super(key: key);

  @override
  State<SavedFilesPreview> createState() => _SavedFilesPreviewState();
}

class _SavedFilesPreviewState extends State<SavedFilesPreview> with WidgetsBindingObserver {
  ServerController server=Get.find();
  var args=Get.arguments;
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  var directFromSaved;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool adshown=false;
  int printer=0;
  int share=0;
  bool isPaused = false;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  var recents;
  @override
  void initState(){
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    //Show AppOpen Ad After 8 Seconds

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );
    appOpenAdManager.loadAd();
    super.initState();
if(args.toString().contains('.png')){
  recents=true;
}
if(args.toString().contains('//')){
  directFromSaved=true;
}
    WidgetsBinding.instance.addObserver(this);
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
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
      log('rpitn:afsafsaf $adshown $printer $share');
    if (state == AppLifecycleState.resumed && adshown&& isPaused&&printer==1||share==1) {
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

    appOpenAdManager.loadAd();
  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return WillPopScope(
      onWillPop: () async{
        if(recents==true){
          var appDir=await getApplicationDocumentsDirectory();
          var dir2='${appDir.path}/Documents/Folders/Recents';
          applicationBloc.showBackAd();
          Get.off(()=>FolderView(),arguments: dir2);

        }else{
          applicationBloc.showBackAd();
          Get.off(()=>FilesandFolders());

        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Container(
            child: Column(

              children: [
                Stack(children: [
                  Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 7.h,
                      child: applicationBloc.is_fileView_banner_Ready == true
                          ? AdWidget(ad: applicationBloc.fileView_banner)
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
                  height: 10.h,
                  decoration: BoxDecoration(color: darkBlue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () async{
                        if(recents==true){
                          var appDir=await getApplicationDocumentsDirectory();
                          var dir2='${appDir.path}/Documents/Folders/Recents';
                          Get.off(()=>FolderView(),arguments: dir2);
                          applicationBloc.showBackAd();
                        }else{
                          Get.off(()=>FilesandFolders());
                          applicationBloc.showBackAd();
                        }

                      }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                      Container(height:35,width:60.w,child: Text(directFromSaved==true?'${args.toString().split('/Folders/')[1].split('//')[1]}':'${args.toString().split('/Folders/')[1].split('/')[1]}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),maxLines: 1,overflow: TextOverflow.fade,))
                      , SizedBox(width: 2,),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: Container(
                    height: 60.h,
                    width: 80.w,


                    child: args.toString().contains('.png')?Image.file(File(args)):PDFView(
                      filePath: args,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: false,
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: args.toString().contains('.png')?[
                    InkWell(
                      onTap: ()async{
                        var file=File(args);
                        Get.defaultDialog(
                          title: 'Are you sure?'.tr,
                          middleText: "Once deleted, the Document cannot be returned".tr,
                          backgroundColor: Colors.lightBlue,
                          barrierDismissible: false,
                          radius: 20.0,
                          confirm: Container(
                            width: 80,
                            child: ElevatedButton(onPressed: () async{
                              await server.deleteFile(file);
                              //await documentController.fetchNewMedia();
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ShowAlbum(SAS: false)));
                              Get.snackbar('Deleted'.tr,'Document Deleted Successfully'.tr,duration: const Duration(seconds: 2),backgroundColor: Colors.red,snackPosition: SnackPosition.BOTTOM);

                              Get.off(()=>FilesandFolders());


                            },
                              child:Center(child: Text('Yes'.tr),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),),
                          ),
                          cancel: Container(width:80,child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child:Center(child: Text('No'),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),),)),
                        );
                      },

                      child: Column(
                        children: [
                          SvgPicture.asset('assets/delete.svg'),
                          Text('Delete',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        adshown=true;
                        Future.delayed(const Duration(seconds: 2)).then((value) =>  share++);
                        server.share(args);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/share.svg'),
                          Text('Share',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async{
                        server.context=context;
                       await server.cropImage(File(args),false);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/server.svg'),
                          Text('Scan',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                  ]: [
                    InkWell(
                      onTap: ()async{
                        var file=File(args);
                        Get.defaultDialog(
                          title: 'Are you sure?'.tr,
                          middleText: "Once deleted, the Document cannot be returned".tr,
                          backgroundColor: Colors.lightBlue,
                          barrierDismissible: false,
                          radius: 20.0,
                          confirm: Container(
                            width: 80,
                            child: ElevatedButton(onPressed: () async{
                              await server.deleteFile(file);
                              //await documentController.fetchNewMedia();
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ShowAlbum(SAS: false)));
                              Get.snackbar('Deleted'.tr,'Document Deleted Successfully'.tr,duration: const Duration(seconds: 2),backgroundColor: Colors.red,snackPosition: SnackPosition.BOTTOM);

                              Get.off(()=>FilesandFolders());


                            },
                              child:Center(child: Text('Yes'.tr),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),),
                          ),
                          cancel: Container(width:80,child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child:Center(child: Text('No'),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),),)),
                        );
                      },

                      child: Column(
                        children: [
                          SvgPicture.asset('assets/delete.svg'),
                          Text('Delete',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        adshown=true;
                        Future.delayed(const Duration(seconds: 2)).then((value) =>  share++);
                        server.share(args);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/share.svg'),
                          Text('Share',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    ),
                   InkWell(
                      onTap: ()async{
                        adshown=true;
                        Future.delayed(const Duration(seconds: 2)).then((value) =>  printer++);
                        var uint=Uint8List.fromList(File(args).readAsBytesSync());
                        await Printing.layoutPdf(onLayout: (_) => uint);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/print.svg'),
                          Text('Print',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}

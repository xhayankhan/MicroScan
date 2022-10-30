import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrapp/Controller/FolderController.dart';
import 'package:ocrapp/Controller/ServerController.dart';
import 'package:ocrapp/Views/HomePage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Constants/Constants.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FolderController folder=Get.find();
  ServerController server=Get.find();
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  var anim=true;
@override
void initState(){
  final applicationBloc = Provider.of<get_ads>(context, listen: false);

  //Show AppOpen Ad After 8 Seconds

  WidgetsBinding.instance.addPostFrameCallback(
        (_) => getads(),
  );
  appOpenAdManager.loadAd();
  super.initState();
}
  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    applicationBloc.createInterstitialStartAd();
    appOpenAdManager.loadAd();
    await applicationBloc.create_homepage_banner_ad();
  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return Scaffold(
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
                  child: applicationBloc.is_homepage_banner_Ready == true
                      ? AdWidget(ad: applicationBloc.homepage_Banner)
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
              SizedBox(
                height: 5.h,
              ),
              Text('Version: 1.0.3',style:TextStyle(color:Color(0xff555557) )),
              Container(
                height: 35.h,
                width: 100.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                         Lottie.asset('assets/landingPageAnim.json'),
                    SvgPicture.asset('assets/loadingbackground.svg'),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'MicroScan',style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff555557),
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        const SizedBox(width: 5,),
                        SvgPicture.asset('assets/lineaftermicroscan.svg')
                      ],
                    ),
                    const Text(
                      'Image to Text\nConverter',style:  TextStyle(
                        fontSize: 28,
                        color: darkBlue,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0,bottom: 8),
                      child:  Text(
                        'Easy Scan, edit and share document\nand save them as PDF or Word Docement',style:  TextStyle(
                          fontSize: 15,
                          color: dullGrey,
                      ),
                      ),
                    ),
                    SvgPicture.asset('assets/3lines.svg'),
                  FutureBuilder(
                    future: animation(),
                    builder: (context,data) {
                      if(anim==true){
                       return Container(height: 0,);
                      }
                      else {
                        return SizedBox(
                          height: 5.h,
                        );
                      }}
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        FutureBuilder(
                          future: animation(),
                          builder: (context,data) {
                            if(anim==false){
                            return InkWell(
                                onTap: ()async{
                                    var version=11.0;
                                   var tr= await Permission.storage.isGranted;
                                  var tra= await Permission.storage.status.isGranted;
                                  if(Platform.isAndroid){
                                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                    version=double.parse(androidInfo.version.release.toString());
                                    print(version.runtimeType);
                                    print("Android ${version} on ${androidInfo.model}"); // e.g. "Moto G (4)"
                                    print(Platform.operatingSystem);
                                  }
                                   if(tr==true||version<11.0){
                                    await folder.fetchNewMedia();
                                  applicationBloc.showInterstitialStartEndAd();
                                    // MobileAds.instance.openAdInspector(
                                    //         (error) {
                                    //       //print(error!.message);
                                    //     });


                                 Get.off(()=>const HomePage());

                                }
                                  else{
                                    Get.defaultDialog(
                                      backgroundColor: dialogueColor,
                                      title: 'Permission Required',
                                       titleStyle: TextStyle(
                                         color: darkBlue,
                                         fontWeight: FontWeight.bold
                                       ),
                                       content: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text('We need storage permission in order to take images from your gallery to get text from them',style: TextStyle(color: darkBlue),),
                                             Text('Go to',style: TextStyle(color: darkBlue),),
                                             Text('Settings>Apps>Micro Scanner>Permissions',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold,fontSize: 14),),
                                             Text('and allow Storage Permission',style: TextStyle(color: darkBlue),),

                                           ],
                                         ),
                                       ),
                                        confirm: InkWell(
                                          onTap: () async{
                                            Navigator.pop(context);
                                            PhotoManager.openSetting();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: darkBlue,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              child: Center(
                                                child: Text('Ok',style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          ),
                                        ),
                                      cancel: InkWell(
                                        onTap: (){
                                          exit(0);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: darkBlue,width: 1)

                                          ),
                                            child: Center(child: Text('Cancel',style: TextStyle(color: darkBlue),)),
                                        ),
                                      )
                                    );

                                  }
                                  },
                                child: SvgPicture.asset('assets/start.svg'));
                          }
                            else{
                              return Container(
                                height: 15.h,
                                  width: 30.w,
                                  child: Lottie.asset('assets/loadingStart.json'));
                            }
                          }
                        )
                      ],
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future animation()async{

    folder.fetchNewMedia();
    var fut=  Future.delayed(const Duration(seconds: 4), () async {


      //await documentController.fetchNewMedia();

      anim=false;
      print("Timeout");
    });
    ///if(fun!=null){
    return fut;
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:ocrapp/Constants/Constants.dart';
import 'package:ocrapp/Controller/FolderController.dart';
import 'package:ocrapp/Controller/ServerController.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';





class NavDrawer extends StatelessWidget {


ServerController server=Get.find();
FolderController folder=Get.find();
@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(

          children: [

                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          lightBlue,
                          darkBlue,
                        ],
                      )
                  ),
                height: 25.h,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Text(
                            'MicroScan',style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                              width: 8.w,
                              child: SvgPicture.asset('assets/lineaftermicroscan.svg',color: Colors.white,))
                        ],
                      ),
                      const Text(
                        'Image to Text\nConverter',style:  TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const Text(
                        'Version: 1.0.1',style:  TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      ),
                    ],
                  ),
                ),
              ),


            Expanded(
              child: Container(
                    height: 75.h,
                decoration: const BoxDecoration(
                 color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[



                    const SizedBox(height: 10,),
                    ListTile(
                      leading: SvgPicture.asset('assets/file.svg',color: darkBlue,),
                      title: Text('Files and Folders'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                        Get.off(()=>const FilesandFolders());
                      },
                    ),
                          const Divider(
                            color: fillColor,
                          ),
                    // ListTile(
                    //   leading: Icon(Icons.help),
                    //   title: Text('Help'.tr,
                    //     style: TextStyle(color: Colors.white),),
                    //   onTap: () async {
                    //
                    //   },
                    // ),





                    ListTile(
                      leading: const Icon(Icons.privacy_tip,color: darkBlue),
                      title: Text('Privacy Policy'.tr,style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                        Get.defaultDialog(
                          backgroundColor: dialogueColor,
                          title: "Privacy Policy",
                          titleStyle: const TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40.h,
                                width: 80.w,
                                child: ListView(
                              children: [
Text('BY ACCESSING OR USING THE Appexsoft Account, YOU AGREE TO BE BOUND BY THE TERMS AND CONDITIONS DESCRIBED HEREIN AND ALL TERMS AND CONDITIONS INCORPORATED BY REFERENCE. THIS PRIVACY POLICY IS PART OF AND INCORPORATED INTO Appexsoft account TERMS OF SERVICE (\"Terms of Service\"). IF YOU DO NOT AGREE TO ALL OF THE TERMS AND CONDITIONS SET FORTH BELOW, YOU MAY NOT USE THE Appexsoft account APPS. By using the account (or just \"the App\" hereafter) in any manner, you acknowledge that you accept the practices and policies outlined in this Privacy Policy, and you hereby consent that we will collect, use, process and share your information as described herein. This Privacy Policy covers our treatment of information that we gather when you are accessing or using our Services. This policy does not apply to the practices of companies that we do not own or control (including, without limitation, the third party content providers from whom you may receive content through the Services), or to individuals that we do not employ or manage. APPS at Appexsoft on Google Play (“Company,” “we,” “us,” “our”) provide you a comprehensive platform Specifically we collect following information necessary for the proper functionality of the App. Our privacy practices will be transparent to you. However we collect only minimal information essentially required for correct functionality of the App, the features of which have been adequately described to the user through Google Play. When you utilize our services, you’re trusting us with your information therefore we understand this is a major obligation and work hard to ensure your data and place you in charge and no piece of information regarding your privacy will NOT be given to third party without your consent under any circumstances')                            ],
                            )),
                          ),                        radius: 20.0,
                          confirm: Container(
                            width: 100,
                            child: ElevatedButton(onPressed: () async {
                              Navigator.pop(context);
                              final Uri url = Uri.parse('https://sites.google.com/view/microscanappex/home');

                              server.launchUrl1(url);
                            },
                              child: const Center(child: Text('See more'),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    darkBlue),),),
                          ),
                          cancel: InkWell(
                            onTap: () {
                              Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: .8.h),
                              width: 80,
                              height: 4.5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: darkBlue,
                                    width: 1
                                ),
                              ),
                              child: const Center(child: Text('Cancel',style: TextStyle(color: darkBlue),),),
                            ),
                          ),);

                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.book,color: darkBlue),
                    //   title: Text('Terms of Services'.tr,
                    //     style: TextStyle(color: darkBlue),),
                    //   onTap: () async {
                    //
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.apps,color: darkBlue),
                      title: Text('More Apps'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                        final Uri url = Uri.parse('https://play.google.com/store/apps/dev?id=4730059111577040107');

                        server.launchUrl1(url);
                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),
                    ListTile(
                      leading: const Icon(Icons.share,color: darkBlue),
                      title: Text('Share App'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                        Share.share('Try this app,\nhttps://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),
                    ListTile(
                      leading: const Icon(Icons.star,color: darkBlue,),
                      title: Text('Rate App'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                        final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

                        server.launchUrl1(url);
                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),
                    ListTile(
                      leading: const Icon(Icons.rate_review,color: darkBlue,),
                      title: Text('Feedback'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                      final Email email = Email(

                      subject: 'FeedBack For Micro Scan App ',
                      recipients: ['appexsoft@gmail.com'],

                      isHTML: false,
                      );

                      await FlutterEmailSender.send(email);


                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),

                    ListTile(
                      leading: const Icon(Icons.exit_to_app,color: darkBlue,),
                      title: Text('Exit'.tr,
                        style: const TextStyle(color: darkBlue),),
                      onTap: () async {
                    folder.openDialog(context);
                      },
                    ),
                    const Divider(
                      color: fillColor,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

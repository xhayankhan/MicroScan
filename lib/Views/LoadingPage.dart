import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
void initState(){
  super.initState();

  final applicationBloc = Provider.of<get_ads>(context, listen: false);

  WidgetsBinding.instance.addPostFrameCallback(
        (_) => getads(),
  );
}
getads() async {
  final applicationBloc = Provider.of<get_ads>(context, listen: false);
  appOpenAdManager.loadAd();
}
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
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
                height: 25.h,
              ),
              Container(
              height: 30.h,
                width: 70.w,
                child: Lottie.asset('assets/loading.json',repeat: true,animate: true,frameRate: FrameRate(60)),

              ),
              SizedBox(
                height: 30,
              ),
              Text('Getting text from your Image!!!!',style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}

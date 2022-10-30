
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'all_adds_id.dart';

class get_ads extends ChangeNotifier{

  // banner at home page
   late BannerAd homepage_Banner;
   bool is_homepage_banner_Ready = false;

   create_homepage_banner_ad(){
    print("get_banner_add called");
    homepage_Banner= BannerAd(
      // Change Banner Size According to Ur Need
       size: AdSize.largeBanner,
        adUnitId: All_Add_Ids.bannerAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (_) {
          print("Successfully Load A Banner Ad");
          is_homepage_banner_Ready = true;
          notifyListeners();
            },
            onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad = ${error}");
          is_homepage_banner_Ready = false;
          notifyListeners();
          ad.dispose();
        }),
        request: AdRequest()
    );
     homepage_Banner.load();
  }
   //Loading home page banner


   //banner at DisplayChapters screen
   late BannerAd homePage_banner;
   bool is_homePage_banner_Ready = false;

   creater_homePage_banner_ad(){
     log("get_banner_add called12321321321321");
     homePage_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.banner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("is_homePage_banner_Ready Successfully Load A Banner Ad");
               is_homePage_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad 2= ${error}");
               is_homePage_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     homePage_banner.load();
   }
   late BannerAd loading_banner;
   bool is_loading_banner_Ready = false;

   creater_loading_banner_ad(){
     log("get_banner_add called12321321321321");
     loading_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.banner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("is_homePage_banner_Ready Successfully Load A Banner Ad");
               is_loading_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad 2= ${error}");
               is_loading_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     loading_banner.load();
   }



   //Banner at display images screen
   late BannerAd files_banner;
   bool is_files_banner_Ready = false;

   create_files_banner_ad(){
     print("get_banner_add called");
     files_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_files_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_files_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     files_banner.load();
   }
   late BannerAd textEdit_banner;
   bool is_textEdit_banner_Ready = false;

   create_textEdit_banner_ad(){
     print("get_banner_add called");
     textEdit_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_textEdit_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_textEdit_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     textEdit_banner.load();
   }
   late BannerAd fileView_banner;
   bool is_fileView_banner_Ready = false;

   create_fileView_banner_ad(){
     print("get_banner_add called");
     fileView_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_fileView_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_fileView_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     fileView_banner.load();
   }
   late BannerAd folder_banner;
   bool is_folder_banner_Ready = false;

   create_folder_banner_ad(){
     print("get_banner_add called");
     folder_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_folder_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_folder_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     folder_banner.load();
   }
   late BannerAd select_banner;
   bool is_select_banner_Ready = false;

   create_select_banner_ad(){
     print("get_banner_add called");
     select_banner= BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.largeBanner,
         adUnitId: All_Add_Ids.bannerAdUnitId,
         listener: BannerAdListener(
             onAdLoaded: (_) {
               print("Successfully Load A Banner Ad");
               is_select_banner_Ready = true;
               notifyListeners();
             },
             onAdFailedToLoad: (ad, LoadAdError error) {
               print("Failed to Load A Banner Ad = ${error}");
               is_select_banner_Ready = false;
               notifyListeners();
               ad.dispose();
             }),
         request: AdRequest()
     );
     select_banner.load();
   }


   static final AdRequest request = AdRequest(
     keywords: <String>['foo', 'bar'],
     contentUrl: 'http://foo.com/bar.html',
     nonPersonalizedAds: true,
   );

   InterstitialAd? interstitialStartAd;
   InterstitialAd? interstitialFileAd;
   InterstitialAd? interstitialScanAd;
   InterstitialAd? interstitialBackAd;
   int _numInterstitialLoadAttempts = 0;
   int maxFailedLoadAttempts = 3;

   void createInterstitialStartAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialStartAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialStartAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialStartAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialStartAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
               createInterstitialStartAd();
             }
           },
         ));
   }
   void createInterstitialFileAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialFileAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialFileAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialFileAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialFileAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialFileAd();

             }
           },
         ));
   }
   void createInterstitialScanAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialScanAdUnitId,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialScanAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialScanAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialScanAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialFileAd();

             }
           },
         ));
   }
   void createInterstitialBackAd() {
     InterstitialAd.load(
         adUnitId: All_Add_Ids.interstitialBackAdID,
         request: request,
         adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (InterstitialAd ad) {
             print('\n $ad loaded');
             interstitialBackAd = ad;
             _numInterstitialLoadAttempts = 0;
             interstitialBackAd!.setImmersiveMode(true);
           },
           onAdFailedToLoad: (LoadAdError error) {
             print('\nInterstitialAd failed to load: $error.');
             _numInterstitialLoadAttempts += 1;
             interstitialBackAd = null;
             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {

               createInterstitialBackAd();

             }
           },
         ));
   }



   void showInterstitialStartEndAd() {
     if (interstitialStartAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialStartAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialStartAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialStartAd();
       },
     );
     interstitialStartAd!.show();
     interstitialStartAd = null;
   }



   void showInterstitialFileAd() {
     if (interstitialFileAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialFileAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialFileAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialFileAd();
       },
     );
     interstitialFileAd!.show();
     interstitialFileAd = null;
   }
   void showInterstitialScanAd() {
     if (interstitialScanAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       return;
     }
     interstitialScanAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialFileAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialFileAd();
       },
     );
     interstitialScanAd!.show();
     interstitialScanAd = null;
   }
   Future<bool> showBackAd() async {

     if (interstitialBackAd == null) {
       print('\nWarning: attempt to show interstitial before loaded.');
       //return;
     }
     interstitialBackAd!.fullScreenContentCallback = FullScreenContentCallback(
       onAdShowedFullScreenContent: (InterstitialAd ad) =>
           print('\nad onAdShowedFullScreenContent.'),
       onAdDismissedFullScreenContent: (InterstitialAd ad) {
         print('$ad onAdDismissedFullScreenContent.');
         ad.dispose();
         createInterstitialBackAd();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
         print('$ad onAdFailedToShowFullScreenContent: $error');
         ad.dispose();
         createInterstitialBackAd();
       },
     );
     interstitialBackAd!.show();
     interstitialBackAd = null;



   return Future.value(true);
   }

}
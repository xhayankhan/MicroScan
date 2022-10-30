
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ocrapp/Views/LandingPage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'AdsController/GettingAdds.dart';
import 'Bindings/Binding.dart';
import 'Constants/Constants.dart';
import 'Views/HomePage.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize()
      .then((initializationStatus) {

    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });

  await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
          //testDeviceIds: ['5DA7BDFCE2454D2BFAA2684F5D1CA485','CA52062D2CB644DAE0657E2CF2B5B27D']
        ));
  FacebookAudienceNetwork.init(
      //testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      //iOSAdvertiserTrackingEnabled: true //default false
  );
  // await MobileAds.instance.updateRequestConfiguration(
  //     RequestConfiguration(testDeviceIds: ['5DA7BDFCE2454D2BFAA2684F5D1CA485']));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp( Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            // ChangeNotifierProvider(create: (_) => TimerInfo()),
            // ChangeNotifierProvider(create: (_) => DirectoryImage()),
            ChangeNotifierProvider(create: (_) => get_ads()),
            // ChangeNotifierProvider(create: (_) => SNC_Lists()),

          ],
          child: GetMaterialApp(home: const LandingPage(),
            builder: EasyLoading.init(),

            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            initialBinding: defaultBinding(),
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            defaultTransition: Transition.leftToRightWithFade,
          ),
        );

      }),
  );
}
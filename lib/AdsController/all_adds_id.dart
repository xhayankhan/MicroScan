import 'dart:io';

class All_Add_Ids {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/9321760867';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/9996795702';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }


  static String get interstitialScanAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/9453622802';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/3418944911';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }


  static String get interstitialStartAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/4392867811';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/3602530322';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialFileAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/1857617089';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/4169753951';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialBackAdID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6044006890313003/9262051113';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6044006890313003/8471713625';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

}
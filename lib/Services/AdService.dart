import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/6300978111";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-3940256099942544/6300978111";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5748985591345133/9083477434";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5748985591345133/9985495565";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  InterstitialAd? interstitialAd;

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd = null;
          Future.delayed(const Duration(seconds: 5), createInterstitialAd);
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          Future.delayed(const Duration(seconds: 5), createInterstitialAd);
        },
      );
      interstitialAd!.show();
    }
  }
}

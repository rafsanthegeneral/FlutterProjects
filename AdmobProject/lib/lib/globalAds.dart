import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? openAd;
BannerAd? bannerad;
RewardedAd? _rewardedAd;
int _rewardCount = 0;
Future<void> loadAd() async {
  var bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-6268658183035073/4756449028',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        print('Banner ad loaded.');
        // You can set the ad to a state variable to display it in the UI
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Banner ad failed to load: $error');
        print('Rewarded ad failed to load with error code: ${error.code}');
        print('Rewarded ad failed to load with message: ${error.message}');
        print('Rewarded ad failed to load with domain: ${error.domain}');
      },
      onAdOpened: (Ad ad) => print('Banner ad opened.'),
      onAdClosed: (Ad ad) => print('Banner ad closed.'),
    ),
  );

  await bannerAd.load();
}

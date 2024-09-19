import 'package:esyearn/lib/globalAds.dart';
import 'package:esyearn/lib/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:esyearn/lib/customeWiget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeeAds extends StatefulWidget {
  @override
  State<SeeAds> createState() => _SeeAdsState();
}

class _SeeAdsState extends State<SeeAds> {
  Operation operation = Operation();
  RewardedAd? _rewardedAd;
  int _rewardCount = 0;
  bool _isAdLoaded = false;
  int _pressCount = 0;
  bool _isButtonEnabled = true;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    loadAd();
    _loadRewardedAd();
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _checkDailyLimit();
  }

  void _checkDailyLimit() {
    String? lastDate = _prefs.getString('lastDate');
    int pressCount = _prefs.getInt('pressCount') ?? 0;

    String today = DateTime.now().toIso8601String().split('T').first;

    if (lastDate == today) {
      _pressCount = pressCount;
    } else {
      _prefs.setString('lastDate', today);
      _prefs.setInt('pressCount', 0);
      _pressCount = 0;
    }

    setState(() {
      _isButtonEnabled = _pressCount < 50;
    });
  }

  void _incrementPressCount() {
    setState(() {
      _pressCount += 1;
      _prefs.setInt('pressCount', _pressCount);
      _isButtonEnabled = _pressCount < 50;
    });
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Error",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(message),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ad unit ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('Rewarded ad loaded.');
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              print('Rewarded ad dismissed.');
              ad.dispose();
              _loadRewardedAd(); // Load a new ad when one is dismissed
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              print('Failed to show rewarded ad: $error');
              ad.dispose();
              _loadRewardedAd(); // Load a new ad when one fails to show
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isButtonEnabled) {
      _incrementPressCount();
      if (_isAdLoaded && _rewardedAd != null) {
        _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            print('User earned reward: ${reward.amount} ${reward.type}');
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor:
                        Colors.green, // Green color for the alert box
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    title: Center(
                      child: Text(
                        "Congratulations!",
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                    ),
                    content: Text(
                      "Get Reward",
                      style: TextStyle(color: Colors.white), // White text color
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white), // White text color
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              operation.updateBlance(0.10); // Get Update one
              print("============================>$_rewardCount");
            });
          },
        );
        _rewardedAd = null;
        _isAdLoaded = false;
      } else {
        _showErrorAlert(context, "Rewarded ad is not ready yet.");
        print('Rewarded ad is not ready yet.');
        // Optionally, inform the user or set up a retry mechanism
      }
    } else {
      _showLimitReachedDialog();
    }
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Limit Reached'),
          content: Text('Enough Click For Today. Please try again tomorrow.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _isButtonEnabled ? _showRewardedAd : null,
          child: Text(
            'See Ad',
            style: TextStyle(fontSize: 24),
          ),
        ),
        if (!_isButtonEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Enough Click For Today',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ElevatedButton(
          onPressed: _isButtonEnabled ? _showRewardedAd : null,
          child: Text(
            'Play game',
            style: TextStyle(fontSize: 24),
          ),
        ),
        if (!_isButtonEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Enough Click For Today',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ElevatedButton(
          onPressed: _isButtonEnabled ? _showRewardedAd : null,
          child: Text(
            'Add Click',
            style: TextStyle(fontSize: 24),
          ),
        ),
        if (!_isButtonEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Enough Click For Today',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    ));
  }
}

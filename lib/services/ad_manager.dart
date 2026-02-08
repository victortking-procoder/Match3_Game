import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedAdReady = false;
  bool _isInterstitialAdReady = false;
  
  // Load Rewarded Ad
  void loadRewardedAd({required Function() onAdLoaded}) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          onAdLoaded();
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              loadRewardedAd(onAdLoaded: () {});
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              loadRewardedAd(onAdLoaded: () {});
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdReady = false;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 5), () {
            loadRewardedAd(onAdLoaded: () {});
          });
        },
      ),
    );
  }
  
  // Show Rewarded Ad
  void showRewardedAd({
    required Function() onRewarded,
    required Function() onAdDismissed,
  }) {
    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded();
        },
      );
      
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          onAdDismissed();
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          loadRewardedAd(onAdLoaded: () {});
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          onAdDismissed();
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          loadRewardedAd(onAdLoaded: () {});
        },
      );
    } else {
      onAdDismissed();
    }
  }
  
  // Load Interstitial Ad
  void loadInterstitialAd({required Function() onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          onAdLoaded();
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              loadInterstitialAd(onAdLoaded: () {});
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              loadInterstitialAd(onAdLoaded: () {});
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 5), () {
            loadInterstitialAd(onAdLoaded: () {});
          });
        },
      ),
    );
  }
  
  // Show Interstitial Ad
  void showInterstitialAd({required Function() onAdDismissed}) {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          onAdDismissed();
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd(onAdLoaded: () {});
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          onAdDismissed();
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd(onAdLoaded: () {});
        },
      );
    } else {
      onAdDismissed();
    }
  }
  
  bool get isRewardedAdReady => _isRewardedAdReady;
  bool get isInterstitialAdReady => _isInterstitialAdReady;
  
  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
  }
}

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
          print('Rewarded ad loaded successfully');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          onAdLoaded();
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Reload immediately
              loadRewardedAd(onAdLoaded: () {});
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Reload immediately
              loadRewardedAd(onAdLoaded: () {});
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
          _isRewardedAdReady = false;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 3), () {
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
      print('Showing rewarded ad');
      
      bool rewardGranted = false;
      
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          rewardGranted = true;
          onRewarded();
        },
      );
      
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Rewarded ad dismissed, reward granted: $rewardGranted');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdDismissed();
          // Reload for next time
          loadRewardedAd(onAdLoaded: () {});
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Rewarded ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdDismissed();
          // Reload for next time
          loadRewardedAd(onAdLoaded: () {});
        },
      );
    } else {
      print('Rewarded ad not ready');
      onAdDismissed();
      // Try to load if not already loading
      if (!_isRewardedAdReady) {
        loadRewardedAd(onAdLoaded: () {});
      }
    }
  }
  
  // Load Interstitial Ad
  void loadInterstitialAd({required Function() onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Interstitial ad loaded successfully');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          onAdLoaded();
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              // Reload immediately
              loadInterstitialAd(onAdLoaded: () {});
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              // Reload immediately
              loadInterstitialAd(onAdLoaded: () {});
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
          _isInterstitialAdReady = false;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 3), () {
            loadInterstitialAd(onAdLoaded: () {});
          });
        },
      ),
    );
  }
  
  // Show Interstitial Ad
  void showInterstitialAd({required Function() onAdDismissed}) {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      print('Showing interstitial ad');
      _interstitialAd!.show();
      
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial ad dismissed');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdDismissed();
          // Reload for next time
          loadInterstitialAd(onAdLoaded: () {});
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdDismissed();
          // Reload for next time
          loadInterstitialAd(onAdLoaded: () {});
        },
      );
    } else {
      print('Interstitial ad not ready, proceeding anyway');
      onAdDismissed();
      // Try to load if not already loading
      if (!_isInterstitialAdReady) {
        loadInterstitialAd(onAdLoaded: () {});
      }
    }
  }
  
  bool get isRewardedAdReady => _isRewardedAdReady;
  bool get isInterstitialAdReady => _isInterstitialAdReady;
  
  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
  }
}

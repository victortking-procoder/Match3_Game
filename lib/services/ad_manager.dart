import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedAdReady = false;
  bool _isInterstitialAdReady = false;
  
  // Load Rewarded Ad
  void loadRewardedAd({Function()? onAdLoaded}) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ Rewarded ad loaded successfully');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          
          // Set callbacks ONCE after loading
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('📺 Rewarded ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('❌ Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Preload next ad
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('⚠️ Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Preload next ad
              loadRewardedAd();
            },
          );
          
          if (onAdLoaded != null) {
            onAdLoaded();
          }
        },
        onAdFailedToLoad: (error) {
          print('❌ Rewarded ad failed to load: ${error.message}');
          _isRewardedAdReady = false;
          _rewardedAd = null;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 5), () {
            loadRewardedAd();
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
      print('🎬 Attempting to show rewarded ad');
      
      bool rewardGranted = false;
      
      // Store the original callback
      final originalCallback = _rewardedAd!.fullScreenContentCallback;
      
      // Update callback to include our custom logic
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('📺 Rewarded ad showed full screen content');
        },
        onAdDismissedFullScreenContent: (ad) {
          print('❌ Rewarded ad dismissed, reward granted: $rewardGranted');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          
          // Call user's callback
          onAdDismissed();
          
          // Preload next ad
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('⚠️ Rewarded ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          
          // Call user's callback even on failure
          onAdDismissed();
          
          // Preload next ad
          loadRewardedAd();
        },
      );
      
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('🎉 User earned reward: ${reward.amount} ${reward.type}');
          rewardGranted = true;
          onRewarded();
        },
      );
    } else {
      print('⚠️ Rewarded ad not ready, proceeding without ad');
      onAdDismissed();
      // Try to load if not already loading
      if (!_isRewardedAdReady) {
        loadRewardedAd();
      }
    }
  }
  
  // Load Interstitial Ad
  void loadInterstitialAd({Function()? onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ Interstitial ad loaded successfully');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          // Set callbacks ONCE after loading
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('📺 Interstitial ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('❌ Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              // Preload next ad
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('⚠️ Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              // Preload next ad
              loadInterstitialAd();
            },
          );
          
          if (onAdLoaded != null) {
            onAdLoaded();
          }
        },
        onAdFailedToLoad: (error) {
          print('❌ Interstitial ad failed to load: ${error.message}');
          _isInterstitialAdReady = false;
          _interstitialAd = null;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 5), () {
            loadInterstitialAd();
          });
        },
      ),
    );
  }
  
  // Show Interstitial Ad
  void showInterstitialAd({required Function() onAdDismissed}) {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      print('🎬 Attempting to show interstitial ad');
      
      // Update callback to include our custom logic
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('📺 Interstitial ad showed full screen content');
        },
        onAdDismissedFullScreenContent: (ad) {
          print('❌ Interstitial ad dismissed');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          
          // Call user's callback
          onAdDismissed();
          
          // Preload next ad
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('⚠️ Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          
          // Call user's callback even on failure
          onAdDismissed();
          
          // Preload next ad
          loadInterstitialAd();
        },
      );
      
      _interstitialAd!.show();
    } else {
      print('⚠️ Interstitial ad not ready, proceeding without ad');
      onAdDismissed();
      // Try to load if not already loading
      if (!_isInterstitialAdReady) {
        loadInterstitialAd();
      }
    }
  }
  
  bool get isRewardedAdReady => _isRewardedAdReady;
  bool get isInterstitialAdReady => _isInterstitialAdReady;
  
  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd = null;
    _interstitialAd = null;
    _isRewardedAdReady = false;
    _isInterstitialAdReady = false;
  }
}

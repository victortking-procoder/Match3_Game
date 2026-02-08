# Quick Start Guide - Match 3 Game

## Getting Started in 3 Steps

### Step 1: Install Flutter
If you don't have Flutter installed:
1. Visit https://docs.flutter.dev/get-started/install
2. Download and install Flutter SDK for your operating system
3. Run `flutter doctor` to verify installation

### Step 2: Setup the Project
```bash
cd match3_game
flutter pub get
```

### Step 3: Run the Game
```bash
# For Android emulator/device
flutter run

# For iOS simulator (Mac only)
flutter run
```

## First Time Playing

1. The game starts with **5 lives** and **Level 1**
2. **Tap** a tile, then tap an adjacent tile to **swap**
3. Match **3 or more** tiles of the same color
4. Reach the **target score** before running out of **moves**

## Understanding the UI

### Top Section
- ❤️ **Lives**: Current lives / Maximum lives (5)
- ⏱️ **Timer**: Shows time until next life regeneration

### Middle Section  
- ⭐ **Level**: Current level number
- 💰 **Coins**: Coins earned from rewarded ads
- 🎯 **Score**: Current score / Target score for the level
- 👆 **Moves**: Remaining moves for the current level

### Game Board
- **8x8 grid** of colored tiles
- **6 colors**: Red, Blue, Green, Yellow, Purple, Orange
- Tap tiles to select and swap

## Ad Integration Points

### ✅ You Will See Ads When:

1. **Completing a level** → Option to watch rewarded ad for 50 coins
2. **Advancing to next level** → Interstitial ad plays automatically
3. **Running out of lives** → Option to watch rewarded ad for 1 extra life
4. **Failing a level** → Option to watch rewarded ad to replay

### ℹ️ During Development
- Ads show as **"Test Ads"** with the Google AdMob test IDs
- This is normal and expected
- Replace with production IDs before publishing to app stores

## Troubleshooting

### Issue: "Ad failed to load"
**Solution**: 
- Make sure you have internet connection
- Test ads may take a few seconds to load
- Retry after a few moments

### Issue: "Command not found: flutter"
**Solution**: 
- Ensure Flutter is installed and added to PATH
- Run `flutter doctor` to diagnose

### Issue: Game won't build
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Android build fails
**Solution**:
- Ensure you have Android SDK installed
- Check that ANDROID_HOME environment variable is set
- Run `flutter doctor` to check setup

## Game Tips

1. **Plan ahead**: Look for potential matches before swapping
2. **Cascade matches**: Create setups where one match leads to another
3. **Watch your moves**: Moves are limited and decrease with higher levels
4. **Save lives**: Watch ads to gain lives when you're close to running out
5. **Earn coins**: Accept rewarded ads after completing levels

## Customization

### Change Ad IDs (For Production)
Edit `lib/services/ad_manager.dart`:
```dart
static const String rewardedAdUnitId = 'YOUR_ID_HERE';
static const String interstitialAdUnitId = 'YOUR_ID_HERE';
```

Also update:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

### Adjust Difficulty
Edit `lib/models/game_board.dart`:
```dart
static int _calculateMoves(int level) {
  return max(15, 30 - level); // Change these values
}

static int _calculateTargetScore(int level) {
  return 100 + (level * 50); // Change these values
}
```

### Change Colors
Edit `lib/widgets/game_board_widget.dart` in the `_getTileColor` method.

## Need Help?

- **Flutter Docs**: https://docs.flutter.dev
- **AdMob Setup**: https://developers.google.com/admob/flutter
- **Flutter Community**: https://flutter.dev/community

## Next Steps

1. ✅ Run the game and test all features
2. ✅ Try completing a few levels
3. ✅ Test all ad scenarios
4. ✅ Customize colors and difficulty if desired
5. ✅ Replace test ad IDs with production IDs
6. ✅ Build release version for deployment

Good luck and have fun! 🎮

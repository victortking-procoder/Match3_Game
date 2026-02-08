# Match 3 Puzzle Game

A minimalist 3-match puzzle game built with Flutter and integrated with Google AdMob.

## Features

- **Classic 3-Match Gameplay**: Swap tiles to match 3 or more of the same color
- **Progressive Difficulty**: Each level increases in difficulty with higher target scores and fewer moves
- **Lives System**: 5 maximum lives that regenerate 1 per hour
- **Coin Rewards**: Earn coins by watching rewarded ads
- **AdMob Integration**: 
  - Interstitial ads shown on level advancement
  - Rewarded ads for earning coins after level completion
  - Rewarded ads for gaining an extra life when out of lives
  - Rewarded ads for replaying a failed level

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode for platform-specific builds
- Google AdMob account

### Installation

1. **Clone or extract the project**
   ```bash
   cd match3_game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS:
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

## Game Mechanics

### How to Play

1. **Tap** a tile to select it
2. **Tap** an adjacent tile to swap
3. Match 3 or more tiles of the same color to score points
4. Reach the target score before running out of moves to complete the level

### Lives System

- You start with 5 lives
- Failing a level costs 1 life
- Lives regenerate at a rate of 1 per hour (up to maximum of 5)
- When out of lives, you can watch a rewarded ad to gain 1 extra life

### Difficulty Progression

- **Moves**: Decreases as level increases (starts at 30, minimum 15)
- **Target Score**: Increases by 50 points per level
- **Tile Colors**: More colors become available at higher levels (up to 6 colors)

### Ads Integration

**Interstitial Ads:**
- Shown automatically when advancing to the next level

**Rewarded Ads:**
- After completing a level: Watch to earn 50 coins
- When out of lives: Watch to gain 1 extra life
- After failing a level: Watch to replay the level

## Ad Unit IDs

The game uses Google AdMob test ad unit IDs:

- **Rewarded Ads**: `ca-app-pub-3940256099942544/5224354917`
- **Interstitial Ads**: `ca-app-pub-3940256099942544/1033173712`

**Note**: These are test IDs. Replace them with your production ad unit IDs before publishing.

### How to Replace Ad IDs

1. Open `lib/services/ad_manager.dart`
2. Replace the test ad unit IDs with your production IDs:
   ```dart
   static const String rewardedAdUnitId = 'YOUR_REWARDED_AD_UNIT_ID';
   static const String interstitialAdUnitId = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
   ```

3. Update the AdMob App IDs:
   - **Android**: `android/app/src/main/AndroidManifest.xml`
   - **iOS**: `ios/Runner/Info.plist`

## File Structure

```
match3_game/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/
│   │   ├── game_board.dart           # Game board logic and 3-match mechanics
│   │   └── game_state.dart           # Lives, coins, and level management
│   ├── services/
│   │   └── ad_manager.dart           # AdMob integration
│   ├── screens/
│   │   └── game_screen.dart          # Main game screen
│   └── widgets/
│       ├── game_board_widget.dart    # Visual game board with tile interactions
│       ├── lives_display.dart        # Lives counter with regeneration timer
│       └── game_info.dart            # Level, score, moves, coins display
├── android/                           # Android configuration
├── ios/                              # iOS configuration
└── pubspec.yaml                      # Dependencies
```

## Dependencies

- `google_mobile_ads: ^5.1.0` - Google AdMob integration
- `shared_preferences: ^2.2.2` - Local data persistence

## Building for Production

### Android

1. Update the application ID in `android/app/build.gradle`
2. Create a keystore for signing
3. Build the release APK:
   ```bash
   flutter build apk --release
   ```

### iOS

1. Update the bundle identifier in Xcode
2. Configure signing certificates
3. Build the release IPA:
   ```bash
   flutter build ios --release
   ```

## Game Rules & Restrictions

- Players cannot play when lives reach 0
- Lives never go below 0
- Maximum of 5 lives at any time
- Rewarded ads must be watched completely to receive rewards
- Interstitial ads are mandatory on level progression

## Testing

The game uses AdMob test IDs, so you'll see test ads during development. Test ads include:
- "Test Ad" label
- Simplified ad content
- No real money transactions

## Support

For issues or questions about:
- Flutter: https://flutter.dev/docs
- AdMob: https://developers.google.com/admob/flutter/quick-start

## License

This project is for educational and personal use.

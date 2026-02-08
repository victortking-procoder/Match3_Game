# APK Build Guide - Match 3 Game

This guide will help you build the Android APK file for the Match 3 puzzle game.

## Prerequisites

Before building the APK, ensure you have:

1. **Flutter SDK** installed (version 3.0.0 or higher)
2. **Android SDK** and **Android Studio** installed
3. **Java JDK** (version 11 or higher)
4. Sufficient disk space (~5GB for Android SDK and build artifacts)

---

## Quick Build (Recommended)

### Option 1: Using Build Scripts

**For Linux/Mac:**
```bash
cd match3_game
chmod +x build_apk.sh
./build_apk.sh
```

**For Windows:**
```cmd
cd match3_game
build_apk.bat
```

The script will automatically:
- Check for Flutter installation
- Clean previous builds
- Get dependencies
- Build the release APK
- Show you the APK location

---

## Manual Build Steps

If the automated scripts don't work, follow these manual steps:

### Step 1: Verify Flutter Installation

```bash
flutter doctor
```

**Expected output:**
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain - develop for Android devices
✓ Android Studio
```

**Fix any ✗ or ! issues before proceeding.**

### Step 2: Navigate to Project

```bash
cd match3_game
```

### Step 3: Clean Previous Builds

```bash
flutter clean
```

### Step 4: Get Dependencies

```bash
flutter pub get
```

### Step 5: Build Release APK

```bash
flutter build apk --release
```

**This will take 3-10 minutes depending on your system.**

### Step 6: Locate the APK

The APK will be generated at:
```
match3_game/build/app/outputs/flutter-apk/app-release.apk
```

**APK Size:** ~20-40 MB (depending on Flutter version)

---

## Alternative Build Options

### Build App Bundle (For Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build Split APKs (Smaller Size)

```bash
flutter build apk --split-per-abi --release
```

This creates separate APKs for different CPU architectures:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### Build Debug APK (For Testing)

```bash
flutter build apk --debug
```

---

## Installing the APK

### Method 1: USB Transfer

1. Connect your Android device via USB
2. Enable USB debugging on your device:
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable "USB Debugging"
3. Copy APK to device:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

### Method 2: File Transfer

1. Copy `app-release.apk` to your device (email, cloud, USB)
2. On your device:
   - Settings → Security → Enable "Install from Unknown Sources"
   - Open the APK file
   - Tap "Install"

### Method 3: Direct Flutter Installation

```bash
flutter install
```
(Requires device connected via USB with debugging enabled)

---

## Troubleshooting

### Error: "Flutter command not found"

**Solution:**
1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Add Flutter to PATH:
   
   **Mac/Linux (add to ~/.bashrc or ~/.zshrc):**
   ```bash
   export PATH="$PATH:/path/to/flutter/bin"
   ```
   
   **Windows (Environment Variables):**
   - Add `C:\path\to\flutter\bin` to System PATH

3. Restart terminal and verify:
   ```bash
   flutter --version
   ```

### Error: "Android SDK not found"

**Solution:**
1. Install Android Studio: https://developer.android.com/studio
2. Open Android Studio → Tools → SDK Manager
3. Install:
   - Android SDK Platform 34 (or latest)
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools
4. Set ANDROID_HOME environment variable:
   
   **Mac/Linux:**
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```
   
   **Windows:**
   ```
   ANDROID_HOME = C:\Users\YourName\AppData\Local\Android\Sdk
   ```

### Error: "Gradle build failed"

**Solution 1 - Clean and Rebuild:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

**Solution 2 - Update Gradle:**
Edit `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
```

**Solution 3 - Clear Gradle Cache:**
```bash
rm -rf ~/.gradle/caches/
```

### Error: "Insufficient storage"

**Solution:**
- Ensure you have at least 5GB free disk space
- Delete previous builds: `flutter clean`
- Clear Flutter cache: `flutter pub cache clean`

### Error: "Java version incompatible"

**Solution:**
1. Install Java JDK 11 or higher
2. Set JAVA_HOME:
   
   **Mac/Linux:**
   ```bash
   export JAVA_HOME=/path/to/jdk-11
   ```
   
   **Windows:**
   ```
   JAVA_HOME = C:\Program Files\Java\jdk-11
   ```

### Build is Very Slow

**Solutions:**
1. Enable Gradle daemon:
   ```
   # In android/gradle.properties
   org.gradle.daemon=true
   org.gradle.parallel=true
   org.gradle.caching=true
   ```

2. Allocate more memory:
   ```
   org.gradle.jvmargs=-Xmx4096m
   ```

3. Use multiple CPU cores:
   ```
   org.gradle.workers.max=4
   ```

### APK Won't Install on Device

**Solutions:**
1. Uninstall any previous version of the app
2. Enable "Install from Unknown Sources"
3. Check device has enough storage
4. Try installing via ADB:
   ```bash
   adb install -r app-release.apk
   ```

---

## Build Optimization

### Reduce APK Size

1. **Enable ProGuard/R8 (already enabled in build.gradle):**
   Shrinks code and removes unused resources

2. **Remove unused resources:**
   ```bash
   flutter build apk --release --split-debug-info=debug-info --obfuscate
   ```

3. **Build split APKs:**
   ```bash
   flutter build apk --split-per-abi --release
   ```

### Optimize Build Time

1. **Use build cache:**
   ```
   # In android/gradle.properties
   org.gradle.caching=true
   ```

2. **Skip lint checks (for testing):**
   ```bash
   flutter build apk --release --no-pub --no-track-widget-creation
   ```

---

## Signing the APK (For Production)

### Step 1: Create Keystore

```bash
keytool -genkey -v -keystore ~/match3-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias match3
```

### Step 2: Reference Keystore

Create `android/key.properties`:
```properties
storePassword=yourStorePassword
keyPassword=yourKeyPassword
keyAlias=match3
storeFile=/path/to/match3-key.jks
```

### Step 3: Update build.gradle

Edit `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 4: Build Signed APK

```bash
flutter build apk --release
```

---

## Verify the Build

### Check APK Contents

```bash
unzip -l build/app/outputs/flutter-apk/app-release.apk
```

### Check APK Size

```bash
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

### Analyze APK

Using Android Studio:
1. Build → Analyze APK
2. Select `app-release.apk`
3. Review size breakdown

---

## Production Checklist

Before publishing to Google Play Store:

- [ ] Replace test AdMob IDs with production IDs
- [ ] Update app name and icon
- [ ] Update version in `pubspec.yaml`
- [ ] Sign APK with production keystore
- [ ] Test on multiple devices
- [ ] Enable ProGuard/R8
- [ ] Build App Bundle instead of APK:
      ```bash
      flutter build appbundle --release
      ```
- [ ] Test in-app purchases and ads
- [ ] Create Privacy Policy
- [ ] Prepare Play Store listing (screenshots, description)

---

## Build Artifacts Location

After successful build, you'll find:

```
build/
├── app/
│   └── outputs/
│       ├── flutter-apk/
│       │   └── app-release.apk          ← Your APK is here
│       └── bundle/release/
│           └── app-release.aab          ← App Bundle (if built)
```

---

## Support

**Flutter Issues:**
- Flutter Documentation: https://docs.flutter.dev
- Flutter GitHub: https://github.com/flutter/flutter/issues

**AdMob Issues:**
- AdMob Documentation: https://developers.google.com/admob/flutter

**Build Issues:**
- Run `flutter doctor -v` for detailed diagnostics
- Check Flutter logs: `flutter logs`

---

## Summary Commands

```bash
# Full build sequence
cd match3_game
flutter clean
flutter pub get
flutter build apk --release

# APK location
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Install to device
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Expected Build Time:** 3-10 minutes  
**Expected APK Size:** 20-40 MB  
**Minimum Android Version:** Android 5.0 (API 21)

---

Good luck with your build! 🚀

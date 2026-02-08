#!/bin/bash

# Match 3 Game - APK Build Script
# This script builds the release APK for the Match 3 puzzle game

echo "=================================="
echo "Match 3 Game - APK Builder"
echo "=================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Error: Flutter is not installed or not in PATH"
    echo ""
    echo "Please install Flutter first:"
    echo "1. Visit: https://docs.flutter.dev/get-started/install"
    echo "2. Download Flutter SDK for your OS"
    echo "3. Add Flutter to your PATH"
    echo "4. Run 'flutter doctor' to verify installation"
    echo ""
    exit 1
fi

echo "✅ Flutter detected: $(flutter --version | head -n 1)"
echo ""

# Navigate to project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📂 Project directory: $SCRIPT_DIR"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Check for issues
echo "🔍 Running Flutter doctor..."
flutter doctor

# Build release APK
echo ""
echo "🔨 Building release APK..."
echo "This may take several minutes..."
echo ""

flutter build apk --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "=================================="
    echo "✅ BUILD SUCCESSFUL!"
    echo "=================================="
    echo ""
    echo "📱 APK Location:"
    echo "   $SCRIPT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📊 APK Size:"
    ls -lh "$SCRIPT_DIR/build/app/outputs/flutter-apk/app-release.apk" | awk '{print "   " $5}'
    echo ""
    echo "📋 Next Steps:"
    echo "   1. Transfer the APK to your Android device"
    echo "   2. Enable 'Install from Unknown Sources' in device settings"
    echo "   3. Open the APK file to install"
    echo "   4. Grant necessary permissions when prompted"
    echo ""
    echo "⚠️  Remember: This APK uses test AdMob IDs"
    echo "   Replace with production IDs before publishing to Play Store"
    echo ""
else
    echo ""
    echo "=================================="
    echo "❌ BUILD FAILED"
    echo "=================================="
    echo ""
    echo "Common solutions:"
    echo "1. Run 'flutter doctor' and fix any issues"
    echo "2. Ensure Android SDK is properly installed"
    echo "3. Check that ANDROID_HOME is set correctly"
    echo "4. Try running: flutter clean && flutter pub get"
    echo ""
    exit 1
fi

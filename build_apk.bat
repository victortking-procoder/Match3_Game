@echo off
REM Match 3 Game - APK Build Script for Windows
REM This script builds the release APK for the Match 3 puzzle game

echo ==================================
echo Match 3 Game - APK Builder
echo ==================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X Error: Flutter is not installed or not in PATH
    echo.
    echo Please install Flutter first:
    echo 1. Visit: https://docs.flutter.dev/get-started/install/windows
    echo 2. Download Flutter SDK for Windows
    echo 3. Add Flutter to your PATH
    echo 4. Run 'flutter doctor' to verify installation
    echo.
    pause
    exit /b 1
)

echo [CHECK] Flutter detected
flutter --version | findstr /C:"Flutter"
echo.

REM Navigate to project directory
cd /d "%~dp0"
echo [INFO] Project directory: %CD%
echo.

REM Clean previous builds
echo [CLEAN] Cleaning previous builds...
call flutter clean

REM Get dependencies
echo [DEPS] Getting dependencies...
call flutter pub get

REM Check for issues
echo [CHECK] Running Flutter doctor...
call flutter doctor

REM Build release APK
echo.
echo [BUILD] Building release APK...
echo This may take several minutes...
echo.

call flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==================================
    echo [CHECK] BUILD SUCCESSFUL!
    echo ==================================
    echo.
    echo [APK] Location:
    echo    %CD%\build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo [INFO] Next Steps:
    echo    1. Transfer the APK to your Android device
    echo    2. Enable 'Install from Unknown Sources' in device settings
    echo    3. Open the APK file to install
    echo    4. Grant necessary permissions when prompted
    echo.
    echo [WARN] Remember: This APK uses test AdMob IDs
    echo    Replace with production IDs before publishing to Play Store
    echo.
    pause
) else (
    echo.
    echo ==================================
    echo [ERROR] BUILD FAILED
    echo ==================================
    echo.
    echo Common solutions:
    echo 1. Run 'flutter doctor' and fix any issues
    echo 2. Ensure Android SDK is properly installed
    echo 3. Check that ANDROID_HOME is set correctly
    echo 4. Try running: flutter clean ^&^& flutter pub get
    echo.
    pause
    exit /b 1
)

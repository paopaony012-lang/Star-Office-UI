@echo off
REM =====================================================
REM Star Office — Android APK Build Script (Windows)
REM =====================================================
echo.
echo 🚀 Star Office APK Builder (Windows)
echo ==========================
echo.

REM Step 1: Install dependencies
echo 📦 Step 1: Installing dependencies...
call npm install

REM Step 2: Add Android platform
if not exist "android" (
    echo 📱 Step 2: Adding Android platform...
    call npx cap add android
) else (
    echo 📱 Step 2: Android platform already exists
)

REM Step 3: Sync web assets
echo 🔄 Step 3: Syncing web assets...
call npx cap sync android

REM Step 4: Build debug APK
echo 🔨 Step 4: Building debug APK...
cd android
call gradlew.bat assembleDebug

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ✅ APK Built Successfully!
    echo 📁 Location: android\app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 📲 Install: adb install app\build\outputs\apk\debug\app-debug.apk
    echo 🏪 Release: gradlew.bat assembleRelease
) else (
    echo ❌ Build failed. Open Android Studio to debug.
)
cd ..
pause

#!/bin/bash
# =====================================================
# Star Office — Android APK Build Script
# =====================================================
# Pre-requisites:
#   - Node.js 18+
#   - Android Studio + Android SDK
#   - Java JDK 17
# =====================================================

echo "🚀 Star Office APK Builder"
echo "=========================="

# Step 1: Install dependencies
echo "📦 Step 1: Installing dependencies..."
npm install

# Step 2: Add Android platform (skip if exists)
if [ ! -d "android" ]; then
    echo "📱 Step 2: Adding Android platform..."
    npx cap add android
else
    echo "📱 Step 2: Android platform already exists"
fi

# Step 3: Sync web assets to Android
echo "🔄 Step 3: Syncing web assets..."
npx cap sync android

# Step 4: Build debug APK
echo "🔨 Step 4: Building debug APK..."
cd android
./gradlew assembleDebug

# Step 5: Check output
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo "✅ APK Built Successfully!"
    echo "📁 Location: android/$APK_PATH"
    echo "📏 Size: $(du -h $APK_PATH | cut -f1)"
    echo ""
    echo "📲 Install on device:"
    echo "   adb install $APK_PATH"
    echo ""
    echo "🏪 For Play Store release:"  
    echo "   ./gradlew assembleRelease"
else
    echo "❌ Build failed. Check Android Studio for errors."
fi

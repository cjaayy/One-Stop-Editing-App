@echo off
echo ========================================
echo One Stop Editor App - Release Builder
echo ========================================
echo.

:: Change to the project root directory (parent of scripts folder)
cd /d "%~dp0.."

:: Clean previous builds
echo Cleaning previous builds...
call flutter clean
echo.

:: Get dependencies
echo Getting dependencies...
call flutter pub get
echo.

:: Show build options
echo ========================================
echo Select build type:
echo ========================================
echo 1. APK (for direct installation)
echo 2. App Bundle (for Play Store)
echo 3. Both
echo.
set /p choice="Enter your choice (1/2/3): "

if "%choice%"=="1" goto BUILD_APK
if "%choice%"=="2" goto BUILD_BUNDLE
if "%choice%"=="3" goto BUILD_BOTH
echo Invalid choice!
goto END

:BUILD_APK
echo.
echo Building Release APK...
call flutter build apk --release
if %errorlevel%==0 (
    echo.
    echo ========================================
    echo APK Build Successful!
    echo ========================================
    echo Location: build\app\outputs\flutter-apk\app-release.apk
    echo.
    :: Open the output folder
    explorer "build\app\outputs\flutter-apk"
) else (
    echo.
    echo Build failed! Check the errors above.
)
goto END

:BUILD_BUNDLE
echo.
echo Building Release App Bundle...
call flutter build appbundle --release
if %errorlevel%==0 (
    echo.
    echo ========================================
    echo App Bundle Build Successful!
    echo ========================================
    echo Location: build\app\outputs\bundle\release\app-release.aab
    echo.
    :: Open the output folder
    explorer "build\app\outputs\bundle\release"
) else (
    echo.
    echo Build failed! Check the errors above.
)
goto END

:BUILD_BOTH
echo.
echo Building Release APK...
call flutter build apk --release
if %errorlevel%==0 (
    echo APK build successful!
) else (
    echo APK build failed!
)
echo.
echo Building Release App Bundle...
call flutter build appbundle --release
if %errorlevel%==0 (
    echo App Bundle build successful!
) else (
    echo App Bundle build failed!
)
echo.
echo ========================================
echo Build Complete!
echo ========================================
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo.
:: Open the APK output folder
explorer "build\app\outputs\flutter-apk"
goto END

:END
echo.
pause

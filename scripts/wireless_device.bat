@echo off
setlocal EnableExtensions
title Wireless ADB Setup

echo ========================================
echo Wireless ADB Setup
echo ========================================
echo.

cd /d "%~dp0.."

set "ADB=%ANDROID_SDK_ROOT%\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=%ANDROID_HOME%\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist "%ADB%" set "ADB=C:\Users\mjhay\AppData\Local\Android\Sdk\platform-tools\adb.exe"

if not exist "%ADB%" (
    echo Could not find adb.exe in the Android SDK platform-tools folder.
    echo Update ANDROID_SDK_ROOT or install Android platform-tools.
    goto END
)

echo This helper pairs and connects a wireless Android device.
echo Enter the full endpoints shown on the phone's Wireless debugging screen.
echo.

set /p PAIR_ENDPOINT=Pairing endpoint (ip:port): 
if "%PAIR_ENDPOINT%"=="" goto CANCEL
set /p PAIRING_CODE=Pairing code: 
if "%PAIRING_CODE%"=="" goto CANCEL
set /p CONNECT_ENDPOINT=ADB connect endpoint (ip:port): 
if "%CONNECT_ENDPOINT%"=="" goto CANCEL

echo.
echo Pairing device...
"%ADB%" pair %PAIR_ENDPOINT% %PAIRING_CODE%
if errorlevel 1 (
    echo.
    echo Pairing failed. Check the IP, port, and pairing code on the phone.
    goto END
)

echo.
echo Connecting device...
"%ADB%" connect %CONNECT_ENDPOINT%
if errorlevel 1 (
    echo.
    echo Connect failed. Check the connect port on the phone.
    goto END
)

echo.
echo Current adb devices:
"%ADB%" devices

echo.
echo Flutter devices:
flutter devices

echo.
echo Note: some Xiaomi / MIUI / HyperOS devices block APK installation over wireless ADB.
echo If flutter run later fails with INSTALL_FAILED_USER_RESTRICTED, enable Install via USB
echo and USB debugging (Security settings) on the phone, or connect it by USB instead.
echo.
set /p RUN_NOW=Run flutter app on this wireless device now? (y/n): 
if /i "%RUN_NOW%"=="y" (
    echo.
    echo Launching Flutter on the connected wireless device...
    flutter run -d %CONNECT_ENDPOINT%
)

goto END

:CANCEL
echo.
echo Cancelled.

:END
echo.
echo Done.
pause
endlocal

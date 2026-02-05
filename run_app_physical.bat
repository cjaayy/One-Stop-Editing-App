@echo off
echo ========================================
echo One Stop Editor App - Physical Device
echo ========================================
echo.

:: Change to the script's directory
cd /d "%~dp0"

:: Check for connected physical devices (exclude emulators and web)
echo Checking for connected physical devices...
flutter devices | findstr /V /C:"emulator" /V /C:"chrome" /V /C:"edge" /V /C:"web" > devices_temp.txt

:: Check if we found any physical devices
findstr /C:"android" devices_temp.txt > nul
if %errorlevel% neq 0 (
    echo.
    echo ============================================
    echo ERROR: No physical device detected!
    echo ============================================
    echo.
    echo Please ensure:
    echo 1. Your phone is connected via USB cable
    echo 2. USB debugging is enabled on your phone
    echo 3. You've authorized this computer on your phone
    echo.
    echo To check connected devices, run: flutter devices
    echo.
    del devices_temp.txt
    pause
    exit /b 1
)

:: Clean up temp file
del devices_temp.txt

echo Physical device detected!
echo.

:: Run the app on the physical device
echo Running Flutter app on physical device...
echo.
call flutter run

pause

::Available Flutter commands while the app is running:
::r - Hot reload (apply code changes instantly)
::R - Hot restart (restart the entire app)
::h - List all interactive commands
::d - Detach (stop Flutter but leave app running)
::c - Clear screen
::q - Quit (stop the app)

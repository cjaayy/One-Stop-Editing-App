@echo off
echo ========================================
echo One Stop Editor App - Physical Device
echo ========================================
echo.

:: Change to the project root directory (parent of scripts folder)
cd /d "%~dp0.."

:: Check for connected physical devices
echo Checking for connected physical devices...

:: Get the device ID of a connected Android physical device
set "DEVICE_ID="
for /f "tokens=2 delims=•" %%a in ('flutter devices ^| findstr /I /C:"android-arm"') do (
    for /f "tokens=1" %%b in ("%%a") do (
        set "DEVICE_ID=%%b"
    )
)

if "%DEVICE_ID%"=="" (
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
    pause
    exit /b 1
)

echo Physical device detected! (ID: %DEVICE_ID%)
echo.

:: Run the app on the specific physical device
echo Running Flutter app on physical device...
echo.
call flutter run -d %DEVICE_ID%

pause

::Available Flutter commands while the app is running:
::r - Hot reload (apply code changes instantly)
::R - Hot restart (restart the entire app)
::h - List all interactive commands
::d - Detach (stop Flutter but leave app running)
::c - Clear screen
::q - Quit (stop the app)

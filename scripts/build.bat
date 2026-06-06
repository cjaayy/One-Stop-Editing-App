@echo off
echo ========================================
echo One Stop Editor App - Build Menu
echo ========================================
echo.

:: Change to the project root directory (parent of scripts folder)
cd /d "%~dp0.."

:: Stop any stale Gradle daemons before starting a new build
echo Stopping existing Gradle daemons...
call android\gradlew.bat --stop > nul 2>&1
echo.

echo Select an option:
echo 1. Build Debug APK
echo 2. Build Release APK
echo 3. Run app on connected device (debug)
echo 4. Run app on connected device (release)
echo 5. Wireless ADB setup
echo 6. Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto DEBUG_APK
if "%choice%"=="2" goto RELEASE_APK
if "%choice%"=="3" goto RUN_DEVICE
if "%choice%"=="4" goto RUN_DEVICE_RELEASE
if "%choice%"=="5" goto WIRELESS_SETUP
if "%choice%"=="6" goto END
echo Invalid choice! Exiting.
goto END

:DEBUG_APK
echo.
echo Building Debug APK...
call flutter build apk --debug
goto END

:RELEASE_APK
echo.
echo Building Release APK...
call flutter build apk --release
if %errorlevel%==0 (
	echo.
	echo ========================================
	echo APK Build Successful!
	echo Location: build\app\outputs\flutter-apk\app-release.apk
	echo.
	echo Installing release APK to the connected device...
	call flutter install build\app\outputs\flutter-apk\app-release.apk
	if %errorlevel%==0 (
		echo.
		echo APK installed successfully.
	) else (
		echo.
		echo APK install failed! Check the device connection and any prompts on the phone.
	)
	echo.
	explorer "build\app\outputs\flutter-apk"
) else (
	echo.
	echo Build failed! Check the errors above.
)
goto END

:RUN_DEVICE
echo.
echo Running Flutter app on connected device (debug)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_device.ps1"
goto END

:RUN_DEVICE_RELEASE
echo.
echo Running Flutter app on connected device (release)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_device.ps1" -Release
goto END

:WIRELESS_SETUP
echo.
echo Opening wireless ADB setup...
call "%~dp0wireless_device.bat"
goto END

:END
echo.
echo Done.
pause

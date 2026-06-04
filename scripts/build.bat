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
echo 3. Build Release App Bundle (AAB)
echo 4. Build Both (Debug APK + Release AAB)
echo 5. Run app on connected device (debug)
echo 6. Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto DEBUG_APK
if "%choice%"=="2" goto RELEASE_APK
if "%choice%"=="3" goto RELEASE_AAB
if "%choice%"=="4" goto BOTH
if "%choice%"=="5" goto RUN_DEVICE
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
	explorer "build\app\outputs\flutter-apk"
) else (
	echo.
	echo Build failed! Check the errors above.
)
goto END

:RELEASE_AAB
echo.
echo Building Release App Bundle...
call flutter build appbundle --release
if %errorlevel%==0 (
	echo.
	echo ========================================
	echo App Bundle Build Successful!
	echo Location: build\app\outputs\bundle\release\app-release.aab
	echo.
	explorer "build\app\outputs\bundle\release"
) else (
	echo.
	echo Build failed! Check the errors above.
)
goto END

:BOTH
echo.
echo Building Debug APK...
call flutter build apk --debug
echo.
echo Building Release App Bundle...
call flutter build appbundle --release
if %errorlevel%==0 (
	echo App Bundle build successful!
	explorer "build\app\outputs\bundle\release"
) else (
	echo App Bundle build failed!
)
goto END

:RUN_DEVICE
echo.
echo Running Flutter app on connected device (debug)...
call flutter run
goto END

:END
echo.
echo Done.
pause

@echo off
echo ========================================
echo One Stop Editor App - Launcher
echo ========================================
echo.

echo Starting Pixel 5 Emulator...
flutter emulators --launch Pixel_5

echo Waiting for emulator to boot...
timeout /t 15 /nobreak

echo.
echo Running Flutter app...
flutter run -d emulator-5554

pause

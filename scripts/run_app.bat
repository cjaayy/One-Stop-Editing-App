@echo off
echo ========================================
echo One Stop Editor App - Launcher
echo ========================================
echo.

:: Change to the project root directory (parent of scripts folder)
cd /d "%~dp0.."

:: Check if Android emulator is already running (look for android-x64)
flutter devices | findstr /C:"android-x64" > nul
if %errorlevel%==0 (
    echo Emulator already running!
    echo.
) else (
    echo Starting Pixel 5 Emulator...
    start "" flutter emulators --launch Pixel_5
    
    echo Waiting for emulator to boot...
    :WAIT_LOOP
    timeout /t 5 /nobreak > nul
    flutter devices | findstr /C:"android-x64" > nul
    if %errorlevel% neq 0 (
        echo Still waiting for emulator...
        goto WAIT_LOOP
    )
    echo Emulator is ready!
    echo.
)

:: Get the actual emulator device ID and run app
echo Running Flutter app...
call flutter run -d emulator-5554

pause

::Available Flutter commands while the app is running:
::r - Hot reload (apply code changes instantly)
::R - Hot restart (restart the entire app)
::h - List all interactive commands
::d - Detach (stop Flutter but leave app running)
::c - Clear screen
::q - Quit (stop the app)
@echo off
REM Clean Flutter build artifacts and remove leftover plugin metadata
flutter clean
if exist .flutter-plugins del /f /q .flutter-plugins
if exist .flutter-plugins-dependencies del /f /q .flutter-plugins-dependencies
if exist build rmdir /s /q build
echo Clean complete.

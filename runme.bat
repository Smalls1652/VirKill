@setlocal enableextensions
@cd /d "%~dp0"
@echo off

title VirKill Downloader

IF NOT EXIST ".\files" ( mkdir ".\files" )

Ping www.google.com -n 1 >NUL
if errorlevel 1 goto :copyfiles

powershell.exe -ExecutionPolicy Bypass -File virkill.ps1

:copyfiles
mkdir %USERPROFILE%\Desktop\VirusTools >NUL

xcopy /S /Y .\files %USERPROFILE%\Desktop\VirusTools

echo.

echo VirKill downloader completed.

pause
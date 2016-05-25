@setlocal enableextensions
@cd /d "%~dp0"
@echo off

title VirKill Downloader (Loading)
color F1

@setlocal enableextensions
@cd /d "%~dp0"
@echo off

IF NOT EXIST ".\files" ( mkdir ".\files" )
set onlyupdate=0
set onlycopy=0

echo Welcome to VirKill, please select an option below.
echo This script was created by Smalls
echo Github page: https://github.com/Smalls1652/VirKill
echo Please report all issues on the GitHub page.
echo.
:askthis

title VirKill Downloader

echo VirKill Menu
echo.
echo.

echo 1. Run
echo 2. Update (Force)
echo 3. Copy
echo 0. Exit

echo.

set /p menunums=Enter menu option: 

echo.

cls
If %menunums% EQU 1 ( goto updatefiles )
If %menunums% EQU 2 ( set onlyupdate=1
					  goto updatefiles )
If %menunums% EQU 3 ( set onlycopy=1
					  goto copyfiles )
If %menunums% EQU 0 ( call exit )

If not %menunums%==1 If not %menunums%==2 If not %menunums%==3 If not %menunums%==0 ( 
cls
echo Please enter a valid menu number.
echo.
goto askthis
)

:updatefiles
If %onlyupdate% EQU 1 ( powershell.exe -ExecutionPolicy Bypass -Command "./virkill.ps1 -force $true" )
If %onlyupdate% EQU 0 ( powershell.exe -ExecutionPolicy Bypass -File virkill.ps1 )

If %onlyupdate% EQU 1 ( echo.
						echo Files have been updated.
						echo.
						set onlyupdate=0
					    goto askthis )

:copyfiles
mkdir %USERPROFILE%\Desktop\VirusTools >NUL

xcopy /S /Y .\files %USERPROFILE%\Desktop\VirusTools

If %onlycopy% EQU 1 ( 	cls
						echo Files have been copied.
						echo.
						set onlycopy=0
					    goto askthis )

echo.

echo VirKill downloader completed.
echo.

goto askthis

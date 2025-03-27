@echo off

set "source=%USERPROFILE%\Pictures\Screenshots"
set "destination=P:\PC\Screenshots"
set "logfile=%USERPROFILE%\Logs\robocopy_sync_log.txt"
set "interval=2"

:loop
echo Syncing at %time%...
robocopy "%source%" "%destination%" /Z /R:5 /W:5 /MT:8 /V /LOG+:"%logfile%"

if %ERRORLEVEL% equ 1 (
    echo Sync Successfull.
)   else if %ERRORLEVEL% equ 0 (
        echo No changes detected.
)   else (
        echo Warning: Issues occured. Check the log at %logfile%.
)

echo Waiting %interval% seconds before next sync...
timeout /t %interval% /nobreak >nul

goto loop
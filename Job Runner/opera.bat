@echo off
setlocal
set "URL=%*"
set "OPERA_PATH=%LOCALAPPDATA%\programs\Opera\opera.exe"

if "%URL%"=="" (
    rem No URL provided, open Opera with a default page
    start "" "%OPERA_PATH%" > nul 2>&1
) else (
    rem URL provided, open Opera with the specified URL
    start "" "%OPERA_PATH%" "%URL%"
)

endlocal

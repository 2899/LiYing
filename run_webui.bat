@echo off
setlocal enabledelayedexpansion

:: Get system language using wmic
for /f "tokens=2 delims==" %%a in ('wmic os get oslanguage /value') do set "LANG_ID=%%a"

:: Convert language ID to language code
if "%LANG_ID%"=="2052" (
    set "LANG=zh"
) else (
    set "LANG=en"
)

set SCRIPT_DIR=%~dp0
set PYTHON_EXE=%SCRIPT_DIR%python-embed\python.exe
cd src\webui
%PYTHON_EXE% app.py --lang=%LANG%
pause

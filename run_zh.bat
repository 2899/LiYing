@echo off
set CLI_LANGUAGE=zh
setlocal enabledelayedexpansion

REM ��ȡ��ǰ�������ļ�Ŀ¼
set SCRIPT_DIR=%~dp0

REM ����Python������·������ĿĿ¼
set PYTHON_EXE=%SCRIPT_DIR%_myPython\python.exe
set SCRIPT_PATH=%SCRIPT_DIR%src\main.py

REM ����Ƿ����ļ���Ŀ¼���Ϸ�
if "%~1"=="" (
    echo �뽫ͼ���ļ���Ŀ¼�Ϸŵ��˽ű���
    pause
    exit /b
)

REM ��ȡ�Ϸŵ�·��
set INPUT_PATH=%~1

echo                  LiYing
echo Github: https://github.com/aoguai/LiYing
echo LICENSE AGPL-3.0 license
echo ----------------------------------------

REM ��ʾ�û��������
set /p "resize=�Ƿ����ͼ��ߴ磨��/��Ĭ���ǣ���"
if /i "!resize!"=="��" (
    set resize=--no-resize
    set save_resized=--no-save-resized
) else (
    set resize=--resize
    set /p "save_resized=�Ƿ񱣴�����ߴ���ͼ����/��Ĭ�Ϸ񣩣�"
    if /i "!save_resized!"=="��" (
        set save_resized=--save-resized
    ) else (
        set save_resized=--no-save-resized
    )
    set /p "photo_type=������Ƭ���ͣ�Ĭ��Ϊһ�磩��"
    if "!photo_type!"=="" set photo_type=һ��
)

set /p "photo_sheet_size=������Ƭ���ߴ磨Ĭ��Ϊ��磩��"
if "!photo_sheet_size!"=="" set photo_sheet_size=���

set /p "compress=�Ƿ�ѹ��ͼ����/��Ĭ�Ϸ񣩣�"
if /i "!compress!"=="��" (
    set compress=--compress
) else (
    set compress=--no-compress
)

set /p "save_corrected=�Ƿ񱣴��������ͼ����/��Ĭ�Ϸ񣩣�"
if /i "!save_corrected!"=="��" (
    set save_corrected=--save-corrected
) else (
    set save_corrected=--no-save-corrected
)

set /p "change_background=�Ƿ������������/��Ĭ�Ϸ񣩣�"
if /i "!change_background!"=="��" (
    set change_background=--change-background
    set /p "rgb_list=����RGBͨ��ֵ�����ŷָ���Ĭ��Ϊ255,255,255����"
    if "!rgb_list!"=="��ɫ" set rgb_list=255,0,0
    if "!rgb_list!"=="��ɫ" set rgb_list=12,92,165
    if "!rgb_list!"=="��ɫ" set rgb_list=255,255,255
    if "!rgb_list!"=="" set rgb_list=255,255,255
    set /p "save_background=�Ƿ񱣴�����������ͼ����/��Ĭ�Ϸ񣩣�"
    if /i "!save_background!"=="��" (
        set save_background=--save-background
    ) else (
        set save_background=--no-save-background
    )
) else (
    set change_background=--no-change-background
    set save_background=--no-save-background
    set rgb_list=255,255,255
)

set /p "sheet_rows=������Ƭ����������Ĭ��Ϊ3����"
if "!sheet_rows!"=="" set sheet_rows=3

set /p "sheet_cols=������Ƭ����������Ĭ��Ϊ3����"
if "!sheet_cols!"=="" set sheet_cols=3

set /p "rotate=�Ƿ���ת��Ƭ90�ȣ���/��Ĭ�Ϸ񣩣�"
if /i "!rotate!"=="��" (
    set rotate=--rotate
) else (
    set rotate=--no-rotate
)

REM ����Ϸŵ���Ŀ���ļ�����Ŀ¼
if exist "%INPUT_PATH%\" (
    REM �����Ŀ¼�������������е�jpg��png�ļ�
    for %%f in ("%INPUT_PATH%\*.jpg" "%INPUT_PATH%\*.png") do (
        REM ��ȡ�ļ���·�����ļ���
        set "INPUT_FILE=%%~ff"
        set "OUTPUT_PATH=%%~dpnf_output%%~xf"
        
        REM ִ��Python�ű�������ͼ��
        start "" cmd /k "%PYTHON_EXE% %SCRIPT_PATH% "%%~ff" -b !rgb_list! -s "%%~dpnf_output%%~xf" -p !photo_type! --photo-sheet-size !photo_sheet_size! !compress! !save_corrected! !change_background! !save_background! -sr !sheet_rows! -sc !sheet_cols! !rotate! !resize! !save_resized! & pause"
    )
) else (
    REM ������ļ���ֱ�Ӵ�����ļ�
    set INPUT_DIR=%~dp1
    set INPUT_FILE=%~nx1
    set OUTPUT_PATH=%INPUT_DIR%%~n1_output%~x1
    
    REM ����ʹ����setlocal enabledelayedexpansion��ʹ��!variable_name!�����ñ���
    start "" cmd /k "%PYTHON_EXE% %SCRIPT_PATH% "!INPUT_PATH!" -b !rgb_list! -s "!OUTPUT_PATH!" -p !photo_type! --photo-sheet-size !photo_sheet_size! !compress! !save_corrected! !change_background! !save_background! -sr !sheet_rows! -sc !sheet_cols! !rotate! !resize! !save_resized! & pause"
)

pause

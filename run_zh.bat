@echo off
set CLI_LANGUAGE=zh
setlocal enabledelayedexpansion

REM ��ȡ��ǰ�������ļ�����Ŀ¼
set SCRIPT_DIR=%~dp0

REM ����Python������·������ĿĿ¼
set PYTHON_EXE=%SCRIPT_DIR%_myPython\python.exe
set SCRIPT_PATH=%SCRIPT_DIR%src\main.py

REM ����Ƿ��Ϸ����ļ���Ŀ¼
if "%~1"=="" (
    echo ���Ϸ�ͼƬ�ļ���Ŀ¼���˽ű���
    pause
    exit /b
)

REM ��ȡ�Ϸŵ�·��
set INPUT_PATH=%~1

echo                  LiYing
echo Github: https://github.com/aoguai/LiYing
echo LICENSE AGPL-3 license
echo ----------------------------------------
REM ѯ���û��������
REM ѯ���û��Ƿ����ͼ��ߴ�
set /p "resize=�Ƿ����ͼ��ߴ磨yes/no��Ĭ��Ϊ yes����"
if /i "!resize!"=="no" (
    set resize=--no-resize
    REM ����û�ѡ�񲻵����ߴ磬��Ĭ�ϲ���������ߴ���ͼ��
    set save_resized=--no-save-resized
) else (
    set resize=--resize
    REM ����û�ѡ������ߴ����û�����루Ĭ��yes������ѯ���Ƿ񱣴�������ͼ��
    set /p "save_resized=�Ƿ񱣴�����ߴ���ͼ��yes/no��Ĭ��Ϊ no����"
    if /i "!save_resized!"=="yes" (
        set save_resized=--save-resized
    ) else (
        set save_resized=--no-save-resized
    )
    REM ѯ����Ƭ����
    set /p "photo_type=������ ��Ƭ���ͣ�Ĭ��Ϊ һ����Ƭ����"
    if "!photo_type!"=="" set photo_type="һ����Ƭ"
)

set /p "photo-sheet-size=������ ��Ƭֽ�ߴ磨Ĭ��Ϊ �����Ƭ����"
if "!photo-sheet-size!"=="" set photo-sheet-size="�����Ƭ"

set /p "compress=�Ƿ�ѹ��ͼ��yes/no��Ĭ��Ϊ yes����"
if /i "!compress!"=="no" set compress=--no-compress
if /i "!compress!"=="yes" set compress=--compress
if /i "!compress!"=="" set compress=--compress

set /p "save_corrected=�Ƿ񱣴�����ͼ����ͼƬ��yes/no��Ĭ��Ϊ no����"
if /i "!save_corrected!"=="yes" set save_corrected=--save-corrected
if /i "!save_corrected!"=="no" set save_corrected=--no-save-corrected

set /p "change_background=�Ƿ��滻������yes/no��Ĭ��Ϊ yes����"
if /i "!change_background!"=="no" (
    set change_background=--no-change-background
    REM ����û�ѡ���滻��������Ĭ�ϲ������滻�������ͼ��
    set save_background=--no-save-background
) else (
    set change_background=--change-background
    REM ѯ�ʱ�����ɫ
    set /p "rgb_list=������ RGB ͨ��ֵ�б����ŷָ���Ĭ��Ϊ 255,255,255����"
    if "!rgb_list!"=="��" set rgb_list=255,0,0
    if "!rgb_list!"=="��" set rgb_list=12,92,165
    if "!rgb_list!"=="��" set rgb_list=255,255,255
    if "!rgb_list!"=="" set rgb_list=255,255,255
    REM ѯ���Ƿ񱣴�������ͼ��
    set /p "save_background=�Ƿ񱣴��滻�������ͼ��yes/no��Ĭ��Ϊ no����"
    if /i "!save_background!"=="yes" (
        set save_background=--save-background
    ) else (
        set save_background=--no-save-background
    )
)

set /p "sheet_rows=������ ��Ƭ����������Ĭ��Ϊ 3����"
if "!sheet_rows!"=="" set sheet_rows=3

set /p "sheet_cols=������ ��Ƭ����������Ĭ��Ϊ 3����"
if "!sheet_cols!"=="" set sheet_cols=3

set /p "rotate=�Ƿ���ת��Ƭ90�ȣ�yes/no��Ĭ��Ϊ no����"
if /i "!rotate!"=="yes" set rotate=--rotate
if /i "!rotate!"=="no" set rotate=

REM �ж��Ϸŵ����ļ�����Ŀ¼
if exist "%INPUT_PATH%\" (
    REM �����Ŀ¼����������е����� jpg �� png �ļ�
    for %%f in ("%INPUT_PATH%\*.jpg" "%INPUT_PATH%\*.png") do (
        REM ��ȡ�ļ���·�����ļ���
        set "INPUT_FILE=%%~ff"
        set "OUTPUT_PATH=%%~dpnf_output%%~xf"
        
        REM ִ��Python�ű�����ͼ��
        start "" cmd /k "%PYTHON_EXE% %SCRIPT_PATH% %%~ff -b %rgb_list% -s %%~dpnf_output%%~xf -p %photo_type% --photo-sheet-size %photo-sheet-size% %compress% %save_corrected% %change_background% %save_background% -sr %sheet_rows% -sc %sheet_cols% %rotate% %resize% %save_resized% & pause"
        
    )
) else (
    REM ������ļ�����ֱ�Ӵ�����ļ�
    set INPUT_DIR=%~dp1
    set INPUT_FILE=%~nx1
    set OUTPUT_PATH=%INPUT_DIR%%~n1_output%~x1

    REM ����ʹ���� setlocal enabledelayedexpansion ��Ҫʹ�� !������! �����ñ���
    start "" cmd /k "%PYTHON_EXE% %SCRIPT_PATH% !INPUT_PATH! -b %rgb_list% -s !OUTPUT_PATH! -p %photo_type% --photo-sheet-size %photo-sheet-size% %compress% %save_corrected% %change_background% %save_background% -sr %sheet_rows% -sc %sheet_cols% %rotate% %resize% %save_resized% & pause"
)

pause


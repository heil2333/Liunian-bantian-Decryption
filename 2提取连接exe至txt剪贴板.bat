@echo off
setlocal EnableDelayedExpansion

:: 设置变量解压缩目录
set "CACHE_DIR=F:\Zipcache"
:: 设置变量归类已完成的文件
set "DONE_DIR=F:\down\#LinkCache"

:: 创建缓存目录（如果不存在）
if not exist "%CACHE_DIR%" (
    mkdir "%CACHE_DIR%"
)
if not exist "%DONE_DIR%" (
    mkdir "%DONE_DIR%"
)

:: 处理拖拽的文件
set "SOURCE_FILE=%~1"
set "FILENAME=%~nx1"
set "FILE_EXT=%~x1"
set "BASE_NAME=%~n1"

:: 检查文件是否存在
if not exist "%SOURCE_FILE%" (
    echo 错误：文件不存在
    pause
    exit /b 1
)

:: 简化文件名检查 - 只需检查是否以.exe结尾
if /i not "%~x1"==".exe" (
    echo 错误：文件不是.exe格式
    pause
    exit /b 1
)

:: 获取当前时间戳（格式：年月日时分秒）
for /f "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set "datetime=%%I"
set "TIMESTAMP=%datetime:~0,14%"

:: 复制文件到缓存目录并重命名为.7z
set "TEMP_7Z=%CACHE_DIR%\temp_archive.7z"
copy /y "%SOURCE_FILE%" "%TEMP_7Z%" >nul

:: 解压文件
echo 正在解压文件...
7z x "%TEMP_7Z%" -o"%CACHE_DIR%\extracted" -y >nul
if errorlevel 1 (
    echo 错误：解压失败，可能文件不是有效的7z压缩包
    goto cleanup
)

:: 查找txt文件
set "TXT_FILE="
for /r "%CACHE_DIR%\extracted" %%f in (*.txt) do (
    if not defined TXT_FILE (
        set "TXT_FILE=%%f"
    )
)

:: 检查是否找到txt文件
if not defined TXT_FILE (
    echo 错误：未找到txt文件
    goto cleanup
)

:: 读取txt文件内容到剪贴板 - 解决中文乱码问题
echo ========================================
powershell -Command "Get-Content -Path '!TXT_FILE!' -Encoding UTF8"
echo ========================================
echo 正在复制文本到剪贴板...
powershell -Command "$content = Get-Content -Path '!TXT_FILE!' -Encoding UTF8 -Raw; if (-not $content) { $content = Get-Content -Path '!TXT_FILE!' -Encoding Default -Raw } $content | Set-Clipboard"
if errorlevel 1 (
    echo 错误：复制到剪贴板失败
    goto cleanup
)


:: 显示成功信息
echo 成功提取文本内容并已复制到剪贴板
echo 文本文件：!TXT_FILE!

:: 移动原始文件到指定文件夹并重命名(非桌面)
:: set "DESKTOP_DIR=%USERPROFILE%\Desktop"这里是桌面

set "NEW_FILENAME=!BASE_NAME!!TIMESTAMP!!FILE_EXT!"

echo 正在移动原始文件到"%DONE_DIR%"...
:: move "%SOURCE_FILE%" "%DESKTOP_DIR%\!NEW_FILENAME!" >nul这里是桌面
move "%SOURCE_FILE%" "%DONE_DIR%\!NEW_FILENAME!" >nul
if errorlevel 1 (
    echo 错误：移动文件失败
    goto cleanup
)

echo 原始文件已移动到桌面并重命名为：!NEW_FILENAME!

:cleanup
:: 清理缓存文件
echo 正在清理缓存文件...
if exist "%TEMP_7Z%" del "%TEMP_7Z%" >nul
if exist "%CACHE_DIR%\extracted" rd /s /q "%CACHE_DIR%\extracted" >nul 2>&1

echo 操作完成！
pause
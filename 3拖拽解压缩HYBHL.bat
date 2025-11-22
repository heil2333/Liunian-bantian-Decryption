@echo off
setlocal

:: 配置参数解压游戏目录
set "target_dir=F:\down\FirstPlay"
:: 配置参数解压缓存文件路径
set "cache_dir=F:\Zipcache"

:: 创建目标目录（如果不存在）
if not exist "%cache_dir%" mkdir "%cache_dir%"
if not exist "%target_dir%" mkdir "%target_dir%"

:: 检查是否通过拖放传递了文件
if "%~1"=="" (
    echo 请将文件拖放到此脚本上执行解压（文件格式exe）
    timeout /t 5
    exit /b
)
cls
:: 处理所有拖放的文件
for %%f in (%*) do (
    echo 正在解压: %%~nxf
    7z x -p"HYBHL" -o"%cache_dir%" "%%f" -y -aoa
    if errorlevel 1 (
        echo [错误] 解压失败: %%~nxf
    ) else (
        echo 解压成功: %%~nxf
    )
)
cls
cd "F:\Zipcache"
for %%g in (*.7删除z) do (
    echo 正在处理二次解压: %%~nxg
    set "orig_file=%%g"
    
    :: 解压并删除临时文件
    7z x -p"HYBHL" -o"%target_dir%" "%%g" -y -aoa
    del /f /q "%%g" >nul
)
cls
echo 已完成!
echo 解压目录（原有覆盖）: %target_dir%
echo 缓存目录（现已清除）：%cache_dir%
timeout /t 3
exit /b
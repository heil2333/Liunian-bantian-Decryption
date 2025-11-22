@echo off
chcp 65001 >nul
title 兽语解密工具 - 循环运行

echo ========================================
echo       兽语解密工具 - 循环运行
echo ========================================

python "%~dp01提取密文.py"

:loop
echo ========================================
echo 兽语密文到剪贴板，然后按回车键开始解密...
pause >nul

echo.
echo 正在运行解密程序...
python "%~dp01提取密文.py"

echo.
echo 按回车键继续下一次解密，或关闭窗口退出...
pause >nul

goto loop
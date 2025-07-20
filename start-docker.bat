@echo off
echo 正在启动v2rayN Docker容器...

REM 检查Docker是否已安装
docker --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker未安装或未正确配置。请安装Docker后再试。
    pause
    exit /b
)

REM 检查Docker Compose是否已安装
docker-compose --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker Compose未安装或未正确配置。请安装Docker Compose后再试。
    pause
    exit /b
)

REM 创建配置目录
if not exist "%~dp0config" (
    echo 创建配置目录...
    mkdir "%~dp0config"
)

REM 构建并启动容器
echo 构建并启动容器...
docker-compose up -d

if %errorlevel% equ 0 (
    echo v2rayN Docker容器已成功启动！
    echo SOCKS代理: 127.0.0.1:10808
    echo HTTP代理: 127.0.0.1:10809
) else (
    echo 启动失败，请检查错误信息。
)

pause
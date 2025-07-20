#!/bin/bash
set -e

echo "正在启动v2rayN Docker容器..."

# 检查Docker是否已安装
if ! command -v docker &> /dev/null; then
    echo "Docker未安装或未正确配置。请安装Docker后再试。"
    exit 1
fi

# 检查Docker Compose是否已安装
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose未安装或未正确配置。请安装Docker Compose后再试。"
    exit 1
fi

# 创建配置目录
if [ ! -d "./config" ]; then
    echo "创建配置目录..."
    mkdir -p "./config"
    chmod 777 "./config"
fi

# 构建并启动容器
echo "构建并启动容器..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo "v2rayN Docker容器已成功启动！"
    echo "SOCKS代理: 127.0.0.1:10808"
    echo "HTTP代理: 127.0.0.1:10809"
else
    echo "启动失败，请检查错误信息。"
fi
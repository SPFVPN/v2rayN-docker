#!/bin/bash
set -e

# 创建配置目录
mkdir -p /config

# 检查是否需要初始化配置
if [ ! -f "/config/guiNConfig.json" ]; then
    echo "初始化配置文件..."
    # 如果配置文件不存在，可以在这里添加初始化逻辑
    # 例如，复制默认配置文件等
fi

# 确保核心文件有执行权限
find /app -type f -name "*" -exec chmod +x {} \;

# 检查TUN模式是否启用
if [ "$ENABLE_TUN" = "true" ]; then
    echo "启用TUN模式..."
    # 这里可以添加TUN模式的初始化逻辑
    # 例如，设置网络接口等
    
    # 使用sudo运行v2rayN（如果需要）
    exec sudo /app/v2rayN "$@"
else
    # 直接运行v2rayN
    exec /app/v2rayN "$@"
fi
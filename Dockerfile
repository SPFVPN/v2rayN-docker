FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 复制源代码
COPY . .

# 构建Linux版本
RUN cd v2rayN && \
    dotnet publish ./v2rayN.Desktop/v2rayN.Desktop.csproj -c Release -r linux-x64 --self-contained=true -o /app/publish && \
    dotnet publish ./AmazTool/AmazTool.csproj -c Release -r linux-x64 --self-contained=true -p:PublishTrimmed=true -o /app/publish

# 下载核心文件
RUN apt-get update && apt-get install -y wget p7zip-full && \
    wget -nv -O v2rayN-linux-64.zip "https://github.com/2dust/v2rayN-core-bin/raw/refs/heads/master/v2rayN-linux-64.zip" && \
    7z x v2rayN-linux-64.zip -o/tmp && \
    cp -rf /tmp/v2rayN-linux-64/* /app/publish/ && \
    echo "When this file exists, app will not store configs under this folder" > /app/publish/NotStoreConfigHere.txt

FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libx11-xcb1 \
    libfontconfig1 \
    libgtk-3-0 \
    libglib2.0-0 \
    libcairo2 \
    libpango-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libxcb-shm0 \
    libxcb-render0 \
    libxrender1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 创建配置目录
RUN mkdir -p /config

# 复制构建的应用
COPY --from=build /app/publish /app

# 复制启动脚本
COPY docker-entrypoint.sh /

# 设置权限
RUN chmod +x /app/v2rayN && \
    chmod +x /app/AmazTool && \
    chmod +x /docker-entrypoint.sh && \
    find /app -type f -name "*" -exec chmod +x {} \;

# 创建符号链接，使配置保存在持久卷中
RUN mkdir -p /root/.config/v2rayN && \
    ln -sf /config /root/.config/v2rayN/config

# 配置sudo无密码
RUN echo "root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root

# 暴露端口
EXPOSE 10808 10809

# 设置卷
VOLUME ["/config"]

# 设置入口点
ENTRYPOINT ["/docker-entrypoint.sh"]
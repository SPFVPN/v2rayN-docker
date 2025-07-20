# v2rayN Docker 部署指南

本文档提供了如何在Docker中部署和使用v2rayN的详细说明。

## 功能特点

- 基于原版v2rayN项目Docker化
- 支持所有v2rayN原有功能
- 支持多种代理协议：VMess、VLESS、Shadowsocks、Trojan、Socks等
- 支持多种核心：Xray、sing-box等
- 提供SOCKS和HTTP代理服务
- 配置持久化存储

## 系统要求

- Docker 19.03+
- Docker Compose v2.0+
- Linux系统（推荐Ubuntu 20.04+或Debian 11+）

## 快速开始

### 使用Docker Compose部署

1. 克隆仓库：

```bash
git clone https://github.com/2dust/v2rayN.git
cd v2rayN
```

2. 构建并启动容器：

```bash
docker-compose up -d
```

3. 查看容器日志：

```bash
docker-compose logs -f
```

### 手动构建和运行

1. 构建Docker镜像：

```bash
docker build -t v2rayn .
```

2. 运行容器：

```bash
docker run -d \
  --name v2rayn \
  -p 10808:10808 \
  -p 10809:10809 \
  -v $(pwd)/config:/config \
  v2rayn
```

## 配置说明

### 端口映射

- `10808`: SOCKS代理端口
- `10809`: HTTP代理端口

可以根据需要在`docker-compose.yml`文件中修改端口映射。

### 持久化存储

配置文件存储在容器的`/config`目录中，通过卷映射到主机的`./config`目录。

### 环境变量

- `DISPLAY`: 用于GUI显示（如果需要）

## 使用TUN模式

如果需要使用TUN模式，需要给容器添加特权：

1. 修改`docker-compose.yml`文件，取消注释以下内容：

```yaml
privileged: true
cap_add:
  - NET_ADMIN
  - SYS_MODULE
```

2. 重新启动容器：

```bash
docker-compose down
docker-compose up -d
```

## 使用代理

容器启动后，可以通过以下方式使用代理：

- SOCKS代理：`127.0.0.1:10808`
- HTTP代理：`127.0.0.1:10809`

## 常见问题

### 1. 容器无法启动

检查日志：

```bash
docker-compose logs
```

### 2. 代理无法连接

确保端口映射正确，并且防火墙允许这些端口的访问。

### 3. 配置文件权限问题

如果遇到配置文件权限问题，可以尝试：

```bash
chmod -R 777 ./config
```

## 高级配置

### 自定义核心文件

如果需要使用自定义的核心文件，可以将文件放在`./config/bin`目录中。

### 使用自定义配置

可以在`./config`目录中手动编辑配置文件。

## 更新

要更新到最新版本，请执行：

```bash
git pull
docker-compose down
docker-compose build
docker-compose up -d
```

## 贡献

欢迎提交问题和改进建议！

## 许可证

与原项目相同的许可证。
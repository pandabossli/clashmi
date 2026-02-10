# Clash Mi (Windows)

本项目当前仅保留 Windows 平台代码。下面说明如何在 Windows 上正确配置与运行项目，以及常见问题的处理方式。

## 环境准备

1. 安装 [Flutter SDK](https://flutter.dev/docs/get-started/install/windows)（建议使用稳定版）。
2. 安装 Git。
3. 安装 Visual Studio 2022（勾选“使用 C++ 的桌面开发”工作负载）。
4. 在 PowerShell 中确认 Flutter 环境：

```powershell
flutter doctor -v
```

确保 `Windows` 相关检查项通过。

## 获取代码

```powershell
git clone https://github.com/KaringX/clashmi.git
cd clashmi
```

## 依赖安装

```powershell
flutter pub get
```

## 运行项目

1. 确保当前仅运行 Windows 目标：

```powershell
flutter config --enable-windows-desktop
flutter devices
```

2. 运行：

```powershell
flutter run -d windows
```

## 常见问题

### 1. `flutter doctor` 提示 Windows 工具链缺失

请安装 Visual Studio 2022，并在安装器中勾选：
- “使用 C++ 的桌面开发”
- Windows 10/11 SDK

重新打开终端后执行：

```powershell
flutter doctor -v
```

### 2. 运行时提示权限不足或无法启动服务

请使用 **管理员权限** 打开终端，再执行：

```powershell
flutter run -d windows
```

### 3. 防火墙提示阻止

允许程序通过防火墙，或在管理员终端中重新运行程序以自动配置端口规则。

### 4. 运行时提示配置/缓存目录异常

尝试清理缓存后重试：

```powershell
flutter clean
flutter pub get
```

### 5. 端口被占用

默认端口被占用时，请关闭相关进程或调整配置后再启动。

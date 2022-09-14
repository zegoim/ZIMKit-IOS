## 概述

本文介绍如何快速跑通示例源码，体验基础的 ZIMKit 集成方案。

## 准备环境

在运行示例源码前，请确保开发环境满足以下要求：

- Xcode 7.0 或以上版本。
- iOS 9.0 或以上版本的 iOS 设备（真机）。
- iOS 设备已经连接到 Internet。

## 前提条件

请联系 ZEGO 技术支持，申请接入 ZIM SDK 服务所需的 AppID 和 AppSign 并配置相关服务权限。

## 示例源码运行指引

### 示例源码目录结构

```bash
├── Podfile ----------------------------------------------工程依赖相关第三方库配置
├── Pods -------------------------------------------------工程依赖相关第三方库
├── ZIMKitDemo.xcworkspace -------------------------------可使用 xcode 打开工程
└── ZIMKitDemo
    ├── AppDelegate.m
    ├── AppDelegate.h
    ├── KeyCenter
    │   ├── KeyCenter.h
    │   └── KeyCenter.m-----------------------------------填写申请的 AppID
    ├── Login ---------------------------------------------登录相关
    ├── Conversation --------------------------------------会话列表相关
    ├── TokenGenerator ------------------------------------生成鉴权token
    ├── zh-Hans.lproj -------------------------------------demo的多语言
    ├── podfile -------------------------------------------demo的相关依赖
    ├── Assets.xcassets -----------------------------------demo的资源图片
    └── Util ----------------------------------------------demo 用到的工具类
```

### 运行示例源码

1. 下载上方示例源码，打开 ZIMKit-IOS/ZIMKitDemo/ZIMKitDemo/KeyCenter 文件夹下的 “KeyCenter.m” 文件，并使用本文 [前提条件] 已获取的 AppID 和 AppSign 正确填写，并保存。

   ```objc
   + (unsigned int)appID {
        return 0; //AppID
    }

   + (NSString *)AppSign{
        return @""; //AppSign
    }
   ```

2. 进入到ZIMKit-IOS/ZIMKitDemo/ 执行pod install 下载需要的依赖库。

   ```bash
    pod install
   ```
3.pod install 完成之后 便可编译运行 。

# 在 Windows 配合 GitHub Actions 构建真机 IPA

## 当前状态

新增的 `Device IPA (unsigned)` 工作流用于先验证上游源码能否生成真机包。它保留原工程的 App、插件运行时、分享扩展、小组件和 Watch target，不改变最低系统版本，也没有完成 iOS 16 移植。

产物是**未签名 IPA**，不是已安装验证的版本。首次运行前无需上传 Apple 证书；安装前仍需用适合设备、App ID 和所需能力的方式签名。普通签名安装时 App Group、HealthKit、HomeKit 等 entitlement 与 profile 必须匹配。不要在 Issue、聊天、工作流文件中粘贴 Token、私钥或证书密码。

## 首次云端构建

1. 把新增的工作流和脚本提交到你自己的 fork 默认分支。本地准备不等于已经提交。
2. 在 fork 的 Actions 中选 `Device IPA (unsigned)`，点击 `Run workflow`。
3. 选择有匹配 Xcode 的 macOS runner。默认 `xcode-27` 和 `/Applications/Xcode_27.2.app` 取自上游现有 CI，只是待验证的默认值；必须确认你的仓库可使用该 runner，镜像上也确有该 Xcode。排队不启动往往需要先检查 runner 是否可用。
4. 成功后从该 run 的 Artifacts 下载未签名 IPA、SHA-256 和 `build-manifest.json`。失败时查看构建日志；依赖准备阶段失败的日志直接看该步骤输出。
5. `build-manifest.json` 记录主 App 和内嵌 bundle 的实际 `MinimumOSVersion`、平台、版本及源码提交。不要只改 plist 或改文件名来宣称支持 iOS 16。

本流程只手动触发，不推送上游、不创建 Release、不发布 TestFlight，也不使用签名 Secret。

## iOS 16.6.1 后续工作

- 将 Observation 状态模型和 iOS 17 SwiftUI API 迁移到可在 iOS 16 运行的实现，包含插件管理和分享 UI。
- 补上旧版 EventKit 授权分支及旧版隐私声明。
- 为 FFmpeg、libgit2，以及检查后的 Node/Python 等依赖提供兼容 iOS 16 的构建；同时检查 Mach-O 最低系统版本和所用符号，而不仅是 Info.plist。
- 分别适配小组件和 Live Activity 的显示、跳转和交互。新系统独有的能力要逐项设计旧系统行为。
- 确认 Watch companion 与 iOS 16 配对环境的兼容策略。
- 在云端编译和链接通过后，再签名并在 iOS 16.6.1 设备检查启动、引擎、插件安装/启停、分享、小组件和必要的本机能力。

在以上验证完成前，本流程的产物不应称为“功能完整的 iOS 16.6.1 版”。

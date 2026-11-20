# 隐私政策 / Privacy Policy

生效日期 / Effective: 2026-11-16

[中文](#中文) · [English](#english)

## 中文

Fish Pocket 是独立的开源社区项目，与深度求索（DeepSeek）不存在隶属、合作、授权或背书关系。

**不登录 Fish Pocket 账号时，我们不收集你的数据。** 这时开发者收不到你的对话、文件、账号或使用情况。只有你选择登录 Fish Pocket 账号使用额度，或者在插件市场举报插件时，才会把数据发给开发者运营的服务器，见下方「Fish Pocket 账号与额度」和「插件举报」。App 里没有广告、分析或第三方追踪 SDK，官方客户端的会话日志上传、消息评价、反馈和使用分析在这个版本里都已关闭。

### 保存在你设备上的内容

会话、工作区文件、设置和模型服务商的凭证都只保存在你的设备上。删除 App 会删除这些内容。

开启远程控制后，Agents Anywhere 的登录凭证保存在这台设备的钥匙串里，退出登录时删除。电脑上的会话内容只在查看时读取，不在手机上另存。

你授权过的本机数据（日历、提醒事项、通讯录、健康、位置、照片、音乐资料库等）不会被 App 另存一份，每次用到都是现读。例外是你明确交给智能体的文件：从照片里导出的那一张、你在文件选择器里选中的那几个，会拷一份进工作区，留到被删除为止。增、删、改默认直接执行，不会每次问你——想让它每次停下来问，或者干脆设成只读，都在「探索 → 本机能力」（iOS 17 的 iPad 上在侧边栏）中按项设置。App 只在本机留一份使用记录：哪项能力、什么操作、什么时候、调用方自报的名字，最近若干条，可以在同一页里查看和清空。

### 会发送到第三方的内容

以下连接都是你使用相应功能时才发生，数据直接发给对方，不经过我们：

- **模型服务商：** 你发送的消息、附件，以及智能体为回答你而读取的文件内容、命令输出和本机数据（你授权之后的日历、提醒事项、通讯录、健康、位置、照片和音乐资料库，以及机型电量这类设备状态），都会发给你选择的模型服务商（默认是 DeepSeek，也可以配置其他服务商）。使用 DeepSeek 官方服务时，请求还带有 App 在本机生成的匿名 ID 和会话 ID。通讯录里是别人的姓名、电话和邮箱，智能体查到的那几位同样会发给模型服务商。这些数据如何处理，由服务商的隐私政策决定。
- **DeepSeek 账号：** 选择账号登录时，登录在 DeepSeek 的官方页面完成，App 读不到你的账号和密码，只保存授权令牌用于调用模型和查询余额。
- **插件：** 打开插件市场时，App 会访问你启用的索引源。默认不启用任何索引源；列为示例的两个第三方索引源（经 jsDelivr 访问的 dsh-market 和 `api.dshfind.com`）要你自己启用。插件图标从索引指定的地址加载。查看插件说明时会访问 npm 文件 CDN 或插件的代码仓库，安装插件时会访问 npm 仓库。这些请求不含你的对话或文件，但对方能看到你的 IP 地址。已安装的插件和智能体运行的命令可以按你的操作访问网络。
- **内置浏览器：** 你访问的网站会收到常规的网络请求。
- **Apple 的系统服务：** 让智能体查天气、查地点或路线时，要查的坐标或地名会发给 Apple 的天气和地图服务，由系统发出。语音转写默认在设备上完成，录音不上传；只有智能体明确改用联网识别时，录音才会发给 Apple。
- **远程控制（可选）：** 只有你在「探索 → 远程控制」（iOS 17 的 iPad 上在侧边栏）里登录 [Agents Anywhere](https://github.com/anywhere-labs/Agents-Anywhere) 之后才会发生。App 会连接你登录的那台 Agents Anywhere 服务器（它的官方云服务，或你自己部署的服务器），读取并显示你电脑上的智能体会话；你在这些会话里发的消息、附件和对审批、提问的回应，经这台服务器转给你的电脑。本机的会话不会发到那里。这些数据如何处理，由 Agents Anywhere 的隐私政策或你自己的服务器决定。
- **更新检查：** App 会向 Apple 和 GitHub 查询最新版本，请求里不含你的个人信息。

### Fish Pocket 账号与额度（可选）

Fish Pocket 账号是可选功能，登录后可以用 App 内购买的额度调用 DeepSeek 模型。只有登录并使用这个功能时，以下数据才会发给开发者运营的 Fish Pocket 服务器：

- **账号信息：** 用 Apple 登录时，Apple 提供的用户标识，以及你同意分享的姓名和邮箱；用手机号登录时，你的手机号和验证码。
- **额度与购买：** 积分余额、App Store 的购买凭证，以及每次调用的模型名称、token 用量和扣除的积分。
- **对话内容：** 选择「Fish Pocket 账号」里的模型时，你发送的内容经 Fish Pocket 服务器转发给提供 DeepSeek 模型的服务商（DeepSeek 官方或其模型的托管服务商），由该服务商按其隐私政策处理。Fish Pocket 服务器只读取用量用于计费，不保存对话内容。

登录凭证保存在本机的钥匙串里。你可以随时在「设置 → Fish Pocket 账号」退出登录，或注销账号；注销后账号无法恢复，剩余积分作废。

### 插件举报（可选）

在插件市场举报插件时，你填写的内容（插件的名称、版本和来源，问题类型，描述和附上的日志）以及 App 的版本号会发给开发者运营的 Fish Pocket 服务器，用于人工审核；登录了 Fish Pocket 账号时还会附上账号标识。举报不会转给插件作者。举报编号和处理进度的记录只保存在你的设备上。

打开插件市场时，App 会从 Fish Pocket 服务器读取已下架插件的名单，用来隐藏这些插件。这个请求不带账号或设备信息。

### 儿童

本 App 不面向 13 岁以下的儿童。

### 政策变更与联系方式

政策变更会更新在这个页面。如有问题，请在 [GitHub](https://github.com/imsai-sh/fish-pocket/issues) 上提问。

## English

Fish Pocket is an independent open-source community project. It is not affiliated with, authorized by or endorsed by DeepSeek.

**Unless you sign in to a Fish Pocket account, we do not collect your data.** Without one, the developer receives none of your conversations, files, account details or usage information. Only if you choose to sign in to Fish Pocket and use its credits, or report a plugin in the plugin market, does the app send data to servers the developer runs; see "Fish Pocket account and credits" and "Plugin reports" below. The app contains no advertising, analytics or third-party tracking SDKs, and the official client's session log upload, message ratings, feedback and usage analytics are turned off in this build.

### What stays on your device

Sessions, workspace files, settings and model provider credentials are stored only on your device. Deleting the app deletes this data.

With remote control turned on, your Agents Anywhere sign-in is kept in this device's keychain and removed when you sign out. Sessions on your computers are read when you look at them and are not stored on the phone.

Device data you have allowed (Calendar, Reminders, Contacts, Health, Location, Photos, your music library and the like) is never copied into the app’s own storage; it is read fresh each time it is used. The exception is a file you hand to the agent yourself: a picture exported from Photos, or files you choose in the file picker, are copied into the workspace and stay there until deleted. Adding, changing and deleting go ahead without asking by default; you can set any capability to ask every time, or to read-only, under Explore › Device capabilities (in the sidebar on an iPad before iOS 18). The app keeps one local record of that use — which capability, which operation, when, and the name the caller gave for itself — for the most recent entries only. You can read and clear it on the same screen.

### What is sent to third parties

These connections happen only when you use the related feature, and the data goes directly to that party, not through us:

- **Model providers:** Your messages and attachments, along with file contents, command output and device data the agent reads to answer you (your Calendar, Reminders, Contacts, Health, Location, Photos and music library once you have allowed them, and device state such as model and battery), are sent to the model provider you choose (DeepSeek by default, and other providers can be configured). Requests to DeepSeek's official service also carry an anonymous ID generated on your device and a session ID. Contacts hold other people's names, phone numbers and email addresses; the ones the agent looks up are sent to the model provider too. How this data is handled is governed by the provider's privacy policy.
- **DeepSeek account:** If you sign in with an account, sign-in happens on DeepSeek's own page. The app cannot read your credentials and stores only an authorization token used to call models and check your balance.
- **Plugins:** Opening the plugin market contacts the index sources you have turned on. None is on by default; the two third-party sources listed as examples (dsh-market, served through jsDelivr, and `api.dshfind.com`) are read only after you turn them on. Plugin icons load from the addresses the index gives. Viewing a plugin's documentation contacts npm file CDNs or the plugin's repository, and installing a plugin contacts the npm registry. These requests do not contain your conversations or files, but those services can see your IP address. Installed plugins and commands run by the agent can access the network as you direct them.
- **Built-in browser:** Websites you visit receive ordinary network requests.
- **Apple system services:** When the agent looks up weather, a place or a route, the coordinates or place name being looked up are sent by iOS to Apple's weather and maps services. Transcription runs on the device by default and the recording is not uploaded; only when the agent explicitly asks for online recognition is the recording sent to Apple.
- **Remote control (optional):** This happens only after you sign in to [Agents Anywhere](https://github.com/anywhere-labs/Agents-Anywhere) under Explore › Remote control (in the sidebar on an iPad before iOS 18). The app connects to the Agents Anywhere server you signed in to (its cloud service, or a server you host yourself) to read and show the agent sessions on your computers; the messages and attachments you send in those sessions, and your answers to approvals and questions, go through that server to your computer. Sessions on this device are never sent there. How this data is handled is governed by Agents Anywhere's privacy policy, or by you for a server of your own.
- **Update check:** The app asks Apple and GitHub for the latest version. These requests contain no personal information.

### Fish Pocket account and credits (optional)

A Fish Pocket account is optional. Once signed in, you can use credits bought in the app to call DeepSeek models. Only when you sign in and use this feature is the following sent to the Fish Pocket servers the developer runs:

- **Account details:** with Sign in with Apple, the user identifier Apple provides and the name and email you choose to share; with a phone number, your number and the verification code.
- **Credits and purchases:** your credit balance, App Store purchase receipts, and for each request the model name, token usage and credits deducted.
- **Conversations:** when you pick a model under "Fish Pocket credits", what you send is forwarded through the Fish Pocket servers to the provider serving the DeepSeek models (DeepSeek itself or a provider hosting its models) and handled under that provider's privacy policy. The Fish Pocket servers read usage for billing only and do not store conversation content.

Sign-in tokens are kept in this device's Keychain. You can sign out or delete your account at any time in Settings → Fish Pocket credits; a deleted account cannot be restored and its remaining credits are forfeited.

### Plugin reports (optional)

When you report a plugin in the plugin market, what you fill in (the plugin's name, version and source, the type of problem, your description and any log you attach) and the app's version are sent to the Fish Pocket servers the developer runs, for review by a person; if you are signed in to Fish Pocket, your account identifier is included. Reports are not passed on to the plugin's author. Your report numbers and their progress are kept only on your device.

When you open the plugin market, the app reads the list of plugins taken down from the Fish Pocket servers, to hide them. This request carries no account or device information.

### Children

This app is not directed at children under 13.

### Changes and contact

Changes to this policy are posted on this page. For questions, open an issue on [GitHub](https://github.com/imsai-sh/fish-pocket/issues).

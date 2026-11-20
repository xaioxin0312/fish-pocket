import SwiftUI

/// The 探索 tab: what the agent can be given beyond a conversation of its own — plugins,
/// connectors, this device's capabilities, phone control — then the other devices (the computers
/// of remote control), the web version and sharing the app, and 设置 behind the gear
/// at its top. On an iPad before iOS 18 these are rows of the sidebar; sharing
/// stays in 设置, and 设置 is a sheet.
struct ExploreTabView: View {
    enum Route: Hashable { case plugins, connectors, capabilities, phoneControl, remote, share, settings }

    @Environment(AppModel.self) private var app
    @Environment(\.scenePhase) private var scenePhase
    @Binding var path: [Route]
    @State private var phoneControl = PhoneControlService()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    row(.plugins, "插件", .plugins, "安装和管理插件")
                    row(.connectors, "连接器", .connectors, "接入 GitHub、Notion 等外部服务", status: connectorStatus)
                    row(.capabilities, "本机能力", .capabilities, "日历、健康、照片等本机数据和功能")
                    row(.phoneControl, "操控手机", .phoneControl, "让智能体点按其他 App", status: phoneControl.state == .running ? String(localized: "运行中") : nil,
                        live: phoneControl.state == .running)
                } header: {
                    Text("扩展智能体")
                }
                Section {
                    row(.remote, "远程控制", .remote, "在手机上管电脑里的智能体", status: remoteStatus,
                        warns: app.remote.expired)
                } header: {
                    Text("更多设备")
                }
                Section {
                    // Opens over everything: the mark of the links that leave the page.
                    Button { Haptics.tap(); app.webRequest = UUID() } label: {
                        label("网页版", .web, "插件自带的界面在这里打开") {
                            Image(systemName: "arrow.up.right").font(.footnote.weight(.semibold)).foregroundStyle(.tertiary)
                        }
                    }
                    .foregroundStyle(Palette.ink)
                    row(.share, "分享 Fish Pocket", .share, "海报、二维码或链接")
                }
            }
            .navigationTitle("探索")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.settings) {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("设置")
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .plugins: PluginStoreView()
                case .connectors: BotConnectorsPage().settingsStyle()
                case .capabilities: NativeCapabilitiesView().environment(\.systemLists, true)
                case .phoneControl: PhoneControlView().environment(\.systemLists, true)
                case .remote: RemoteControlPage().environment(\.systemLists, true)
                case .share: ShareAppPage()
                case .settings: SettingsView(pushed: true)
                }
            }
            // iCTRL can start or stop while the user is in another app.
            .task { await phoneControl.refresh() }
            .onChange(of: scenePhase) { _, phase in
                guard phase == .active else { return }
                Task { await phoneControl.refresh() }
            }
        }
        // 设置 and the pages pushed from it wear the settings look, which a page takes from the
        // stack it is in: on while 设置 is what this one shows. The other pages keep their own.
        .environment(\.systemLists, path.first == .settings)
        .inkTint()
    }

    /// Once signed in: computers online, offline, or the sign-in to renew. Before, the line under
    /// the name already says what it is for.
    private var remoteStatus: String? {
        let remote = app.remote
        return remote.signedIn || remote.expired ? DrawerView.remoteControlNote(remote) : nil
    }

    private var connectorStatus: String? {
        let team = app.botTeam
        let connected = team.status == .ready ? team.connectors.filter { $0["state"].string == "ready" }.count : 0
        return connected > 0 ? String(localized: "\(connected) 个已连接") : nil
    }

    private func row(_ route: Route, _ title: LocalizedStringKey, _ icon: ExploreGlyph.Kind, _ detail: LocalizedStringKey,
                     status: String? = nil, warns: Bool = false, live: Bool = false) -> some View {
        NavigationLink(value: route) {
            label(title, icon, detail) {
                if let status {
                    HStack(spacing: 5) {
                        if live { Circle().fill(.green).frame(width: 7, height: 7) }
                        Text(status)
                    }
                    .font(.footnote)
                    .foregroundStyle(warns ? Palette.waiting : Palette.secondary)
                    .lineLimit(1)
                }
            }
        }
    }

    /// The entry's drawn icon, the name and a line on what it is for, and what it says on the right.
    private func label(_ title: LocalizedStringKey, _ icon: ExploreGlyph.Kind, _ detail: LocalizedStringKey,
                       @ViewBuilder trailing: () -> some View) -> some View {
        HStack(spacing: 14) {
            ExploreGlyph(kind: icon)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.body).foregroundStyle(Palette.ink)
                Text(detail).font(.footnote).foregroundStyle(Palette.secondary).lineLimit(2)
            }
            Spacer(minLength: 8)
            // The status whole first: cut short it says nothing ("1…" for one service connected),
            // and the line under the name has a second row to go to.
            trailing().layoutPriority(1)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

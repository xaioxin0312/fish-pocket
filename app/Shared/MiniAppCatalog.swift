import AppIntents
import Foundation
import SwiftUI

/// Mini Apps listed for the app and its Shortcuts actions.
struct MiniAppSummary: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    /// An emoji.
    let icon: String
    /// `#RRGGBB`.
    let color: String
}

enum MiniAppCatalog {
    private static var fileURL: URL? {
        guard let groupId = Bundle.main.object(forInfoDictionaryKey: "DshAppGroup") as? String,
              let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else { return nil }
        return container.appending(path: "mini-apps.json")
    }

    static func read() -> [MiniAppSummary] {
        guard let url = fileURL, let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([MiniAppSummary].self, from: data)) ?? []
    }

    @discardableResult
    static func write(_ apps: [MiniAppSummary]) -> Bool {
        guard apps != read(), let url = fileURL, let data = try? JSONEncoder().encode(apps) else { return false }
        try? data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        return true
    }
}

extension Color {
    /// An app's `color`: `#RRGGBB`; anything else is gray.
    init(miniApp hex: String) {
        let digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard digits.count == 6, let value = UInt32(digits, radix: 16) else {
            self = Color(red: 0.56, green: 0.56, blue: 0.58)
            return
        }
        self = Color(red: Double(value >> 16 & 0xFF) / 255, green: Double(value >> 8 & 0xFF) / 255, blue: Double(value & 0xFF) / 255)
    }
}

struct MiniAppEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Mini App"
    static var defaultQuery = MiniAppQuery()

    let id: String
    let name: String
    let icon: String

    init(_ app: MiniAppSummary) {
        id = app.id
        name = app.name
        icon = app.icon
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: "\(icon) \(name)"))
    }
}

struct MiniAppQuery: EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [MiniAppEntity] {
        let apps = MiniAppCatalog.read()
        return identifiers.compactMap { id in apps.first { $0.id == id }.map(MiniAppEntity.init) }
    }

    func entities(matching string: String) async throws -> [MiniAppEntity] {
        MiniAppCatalog.read().filter { $0.name.localizedCaseInsensitiveContains(string) }.map(MiniAppEntity.init)
    }

    func suggestedEntities() async throws -> [MiniAppEntity] {
        MiniAppCatalog.read().map(MiniAppEntity.init)
    }
}

/// Opens one Mini App. Added to the home screen from Shortcuts, it is the app's own icon there.
struct OpenMiniAppIntent: AppIntent {
    static var title: LocalizedStringResource = "打开 Mini App"
    static var description = IntentDescription("打开一个 Mini App。在快捷指令里把它添加到主屏幕，就是这个 Mini App 的图标。")
    static var openAppWhenRun = true

    @Parameter(title: "Mini App")
    var app: MiniAppEntity

    static var parameterSummary: some ParameterSummary {
        Summary("打开\(\.$app)")
    }

    init() {}

    init(app: MiniAppEntity) {
        self.app = app
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        DshIntentBridge.open?(.app(app.id))
        return .result()
    }
}

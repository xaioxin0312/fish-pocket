import AppIntents
import Foundation

/// Siri and Shortcuts. The intent runs in the app, where `DshIntentBridge` hands the link to a window.
struct NewConversationIntent: AppIntent {
    static var title: LocalizedStringResource = "新对话"
    static var description = IntentDescription("打开 Fish Pocket，开始一个新对话。")
    static var openAppWhenRun = true

    @Parameter(title: "草稿", description: "放进输入框，不会自动发送。")
    var draft: String?

    init() {}

    init(draft: String?) {
        self.draft = draft
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        DshIntentBridge.open?(.new(draft: draft?.isEmpty == false ? draft : nil))
        return .result()
    }
}

/// Set by the app at launch; nil in the extension (the intent never runs there).
enum DshIntentBridge {
    @MainActor static var open: ((DshLink) -> Void)?
}

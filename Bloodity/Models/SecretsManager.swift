import Foundation

struct SecretsManager {
    static let shared = SecretsManager()

    private var secrets: [String: String] = [:]

    init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
            secrets = dict
        }
    }

    var geminiAPIKey: String {
        secrets["GEMINI_API_KEY"] ?? ""
    }

    var gptAPIKey: String {
        secrets["GPT_API_KEY"] ?? ""
    }

    var githubPAT: String {
        secrets["GITHUB_PAT"] ?? ""
    }

    var geminiModel: String {
        secrets["GEMINI_MODEL"] ?? "gemini-2.5-flash"
    }

    var gptModel: String {
        secrets["GPT_MODEL"] ?? "gpt-4.1-mini"
    }
}

@testable import LanguageModelChatUI
import Foundation
import Testing

struct InputEditorLocalizationTests {
    @Test("Chat input placeholder includes app-supported localizations")
    func chatInputPlaceholderIncludesAppSupportedLocalizations() throws {
        let expectations: [(locale: String, expected: String)] = [
            ("ja", "入力してください..."),
            ("ko", "입력해 주세요..."),
            ("vi", "Nhập nội dung..."),
            ("zh-Hant", "輸入點什麼..."),
        ]

        for expectation in expectations {
            let localizedText = try #require(
                localizedString(for: "Type something...", locale: expectation.locale)
            )
            #expect(localizedText == expectation.expected)
        }
    }

    private func localizedString(for key: String, locale: String) -> String? {
        let bundle = LanguageModelChatInterfaceConfiguration.localizationBundle
        guard let languagePath = bundle.path(forResource: locale, ofType: "lproj") else {
            return nil
        }
        guard let localizedBundle = Bundle(path: languagePath) else {
            return nil
        }
        return localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

@testable import LanguageModelChatUI
import Testing
import UIKit

@MainActor
struct ChatInputConfigurationTests {
    @Test("Default chat input configuration keeps optional buttons enabled")
    func defaultConfigurationKeepsButtonsEnabled() {
        let configuration = ChatInputConfiguration()

        #expect(configuration.showsCameraButton)
        #expect(configuration.showsVoiceButton)
        #expect(configuration.showsMoreButton)
    }

    @Test("Input editor hides disabled buttons in standard layout")
    func standardLayoutHidesDisabledButtons() {
        let editor = InputEditor()
        editor.configuration = ChatInputConfiguration(
            pasteLargeTextAsFile: false,
            compressImage: true,
            quickSettingItems: [],
            controlPanelItems: [],
            showsCameraButton: false,
            showsVoiceButton: false,
            showsMoreButton: false
        )
        editor.textHeight.send(22)
        editor.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        editor.layoutStatus = .standard

        editor.layoutIfNeeded()

        #expect(editor.bossButton.isHidden)
        #expect(editor.voiceButton.isHidden)
        #expect(editor.moreButton.isHidden)
        #expect(editor.textView.frame.minX == 10)
        #expect(editor.textView.frame.maxX == 310)
    }

    @Test("Input editor keeps send button while hiding disabled buttons during editing")
    func editingLayoutKeepsSendButtonVisible() {
        let editor = InputEditor()
        editor.configuration = ChatInputConfiguration(
            pasteLargeTextAsFile: false,
            compressImage: true,
            quickSettingItems: [],
            controlPanelItems: [],
            showsCameraButton: false,
            showsVoiceButton: false,
            showsMoreButton: false
        )
        editor.textView.text = "hello"
        editor.textHeight.send(22)
        editor.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        editor.layoutStatus = .editingText

        editor.layoutIfNeeded()

        #expect(editor.bossButton.isHidden)
        #expect(editor.voiceButton.isHidden)
        #expect(editor.moreButton.isHidden)
        #expect(!editor.sendButton.isHidden)
        #expect(editor.sendButton.alpha == 1)
        #expect(editor.textView.frame.minX == 10)
        #expect(editor.textView.frame.maxX < editor.sendButton.frame.minX)
    }
}

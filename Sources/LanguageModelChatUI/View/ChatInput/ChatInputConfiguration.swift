//
//  ChatInputConfiguration.swift
//  LanguageModelChatUI
//

import UIKit

/// Configuration for the chat input view behavior and contents.
@MainActor
public struct ChatInputConfiguration {
    public var pasteLargeTextAsFile: Bool
    public var compressImage: Bool
    public var quickSettingItems: [QuickSettingItem]
    public var controlPanelItems: [ControlPanelItem]
    public var showsCameraButton: Bool
    public var showsVoiceButton: Bool
    public var showsMoreButton: Bool

    public static let `default` = ChatInputConfiguration()

    public init(
        pasteLargeTextAsFile: Bool = true,
        compressImage: Bool = true,
        quickSettingItems: [QuickSettingItem] = [],
        controlPanelItems: [ControlPanelItem] = ControlPanelItem.defaults,
        showsCameraButton: Bool = true,
        showsVoiceButton: Bool = true,
        showsMoreButton: Bool = true
    ) {
        self.pasteLargeTextAsFile = pasteLargeTextAsFile
        self.compressImage = compressImage
        self.quickSettingItems = quickSettingItems
        self.controlPanelItems = controlPanelItems
        self.showsCameraButton = showsCameraButton
        self.showsVoiceButton = showsVoiceButton
        self.showsMoreButton = showsMoreButton
    }
}

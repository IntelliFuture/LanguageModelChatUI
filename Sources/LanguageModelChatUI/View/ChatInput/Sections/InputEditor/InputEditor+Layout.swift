//
//  InputEditor+Layout.swift
//  LanguageModelChatUI
//

import UIKit

extension InputEditor {
    private var showsCameraButton: Bool { configuration.showsCameraButton }
    private var showsVoiceButton: Bool { configuration.showsVoiceButton }
    private var showsMoreButton: Bool { configuration.showsMoreButton }

    func setButton(
        _ button: UIView,
        frame: CGRect,
        isVisible: Bool,
        hiddenTransform: CGAffineTransform? = nil
    ) {
        button.frame = frame
        button.isHidden = !isVisible
        button.isUserInteractionEnabled = isVisible
        button.alpha = isVisible ? 1 : 0
        if let hiddenTransform, !isVisible {
            button.transform = hiddenTransform
        } else {
            button.transform = .identity
        }
    }

    func textLayoutHeight(_ input: CGFloat) -> CGFloat {
        var finalHeight = input
        finalHeight = max(font.lineHeight, finalHeight)
        finalHeight = min(finalHeight, maxTextEditorHeight)
        return ceil(finalHeight)
    }

    func switchToRequiredStatus() {
        assert(Thread.isMainThread)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(switchToRequiredStatusEx), object: nil)
        perform(#selector(switchToRequiredStatusEx), with: nil, afterDelay: 0.1)
    }

    @objc private func switchToRequiredStatusEx() {
        doWithAnimation { [self] in
            bossButton.transform = .identity
            moreButton.transform = .identity
            sendButton.transform = .identity
            voiceButton.transform = .identity
            if textView.isFirstResponder {
                if textView.text.isEmpty {
                    layoutStatus = .preFocusText
                } else {
                    layoutStatus = .editingText
                }
            } else {
                if textView.text.isEmpty {
                    layoutStatus = .standard
                } else {
                    layoutStatus = .editingText
                }
            }
        }
    }

    func layoutAsEditingText() {
        setButton(
            sendButton,
            frame: CGRect(
            x: bounds.width - inset.right - iconSize.width,
            y: bounds.height - iconSize.height - inset.bottom,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: true
        )
        setButton(
            moreButton,
            frame: CGRect(
            x: bounds.width - inset.right - iconSize.width,
            y: bounds.height - iconSize.height - inset.bottom,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: false,
            hiddenTransform: CGAffineTransform(scaleX: 0.5, y: 0.5)
        )

        let voiceFrame = CGRect(
            x: sendButton.frame.minX - iconSize.width - iconSpacing,
            y: sendButton.frame.minY,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(voiceButton, frame: voiceFrame, isVisible: showsVoiceButton)

        let textLayoutHeight = textLayoutHeight(textHeight.value)
        let textMaxX = showsVoiceButton
            ? voiceButton.frame.minX - iconSpacing
            : sendButton.frame.minX - iconSpacing
        textView.frame = CGRect(
            x: inset.left,
            y: (bounds.height - textLayoutHeight) / 2,
            width: textMaxX - inset.left,
            height: textLayoutHeight
        )
        placeholderLabel.frame = textView.frame

        setButton(
            bossButton,
            frame: CGRect(
            x: 0 - inset.left - iconSize.width,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: false
        )
    }

    func layoutAsPreEditingText() {
        setButton(
            bossButton,
            frame: CGRect(
            x: 0 - inset.left - iconSize.width,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: false,
            hiddenTransform: CGAffineTransform(scaleX: 0.5, y: 0.5)
        )

        let moreFrame = CGRect(
            x: bounds.width - inset.right - iconSize.width,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(moreButton, frame: moreFrame, isVisible: showsMoreButton)

        let voiceX = (showsMoreButton ? moreButton.frame.minX : bounds.width - inset.right) - iconSize.width - iconSpacing
        let voiceFrame = CGRect(
            x: voiceX,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(voiceButton, frame: voiceFrame, isVisible: showsVoiceButton)

        let textLayoutHeight = textLayoutHeight(textHeight.value)
        let textMaxX: CGFloat
        if showsVoiceButton {
            textMaxX = voiceButton.frame.minX - iconSpacing
        } else if showsMoreButton {
            textMaxX = moreButton.frame.minX - iconSpacing
        } else {
            textMaxX = bounds.width - inset.right
        }
        textView.frame = CGRect(
            x: inset.left,
            y: (bounds.height - textLayoutHeight) / 2,
            width: textMaxX - inset.left,
            height: textLayoutHeight
        )
        textView.alpha = 1
        placeholderLabel.frame = textView.frame

        setButton(
            sendButton,
            frame: CGRect(
            x: bounds.width + iconSpacing + inset.right,
            y: bounds.height - iconSize.height - inset.bottom,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: false,
            hiddenTransform: CGAffineTransform(scaleX: 0.5, y: 0.5)
        )
    }

    func layoutAsStandard() {
        let cameraFrame = CGRect(
            x: inset.left,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(bossButton, frame: cameraFrame, isVisible: showsCameraButton)

        let moreFrame = CGRect(
            x: bounds.width - inset.right - iconSize.width,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(moreButton, frame: moreFrame, isVisible: showsMoreButton)

        let voiceX = (showsMoreButton ? moreButton.frame.minX : bounds.width - inset.right) - iconSize.width - iconSpacing
        let voiceFrame = CGRect(
            x: voiceX,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        )
        setButton(voiceButton, frame: voiceFrame, isVisible: showsVoiceButton)

        let textLayoutHeight = textLayoutHeight(textHeight.value)
        let textMinX = showsCameraButton ? bossButton.frame.maxX + iconSpacing : inset.left
        let textMaxX: CGFloat
        if showsVoiceButton {
            textMaxX = voiceButton.frame.minX - iconSpacing
        } else if showsMoreButton {
            textMaxX = moreButton.frame.minX - iconSpacing
        } else {
            textMaxX = bounds.width - inset.right
        }
        textView.frame = CGRect(
            x: textMinX,
            y: (bounds.height - textLayoutHeight) / 2,
            width: textMaxX - textMinX,
            height: textLayoutHeight
        )
        textView.alpha = 1
        placeholderLabel.frame = textView.frame

        setButton(
            sendButton,
            frame: CGRect(
            x: bounds.width + inset.right,
            y: inset.top,
            width: iconSize.width,
            height: iconSize.height
        ),
            isVisible: false,
            hiddenTransform: CGAffineTransform(scaleX: 0.5, y: 0.5)
        )
    }
}

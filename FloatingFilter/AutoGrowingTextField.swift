//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class AutoGrowingTextField: NSTextField {
    private var placeholderWidth: CGFloat? = 0

    /// Field editor inset; experimental value
    private let rightMargin: CGFloat = 5

    private var lastSize: NSSize?
    private var isEditing = false

    override func awakeFromNib() {
        super.awakeFromNib()

        if let placeholderString = self.placeholderString {
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var placeholderString: String? {
        didSet {
            guard let placeholderString = self.placeholderString else { return }
            self.placeholderWidth = sizeForProgrammaticText(placeholderString).width
        }
    }

    override var stringValue: String {
        didSet {
            guard !isEditing else { return }
            self.lastSize = sizeForProgrammaticText(stringValue)
        }
    }

    private func sizeForProgrammaticText(_ string: String) -> NSSize {
        let font = self.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        let stringWidth = NSAttributedString(
            string: string,
            attributes: [ .font : font ])
            .size().width

        // Don't use `self` to avoid cycles
        var size = super.intrinsicContentSize
        size.width = stringWidth
        return size
    }

    override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isEditing = true
    }

    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isEditing = false
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: NSSize {
        var minSize: NSSize {
            var size = super.intrinsicContentSize
            size.width = self.placeholderWidth ?? 0
            return size
        }

        // Use cached value when not editing
        guard isEditing,
            let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView
            else { return self.lastSize ?? minSize }

        // Make room for the placeholder when the text field is empty
        guard !fieldEditor.string.isEmpty else {
            self.lastSize = minSize
            return minSize
        }

        // Use the field editor's computed width when possible
        guard let container = fieldEditor.textContainer,
            let newWidth = container.layoutManager?.usedRect(for: container).width
            else { return self.lastSize ?? minSize }

        var newSize = super.intrinsicContentSize
        newSize.width = newWidth + rightMargin

        self.lastSize = newSize

        return newSize
    }
}

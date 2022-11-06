//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

@objc protocol ArrowKeyableTextFieldDelegate: class {
    func arrowKeyableTextFieldDidCommit(_ textField: ArrowKeyableTextField)

    func arrowKeyableTextFieldSelectFirst(_ textField: ArrowKeyableTextField)
    func arrowKeyableTextFieldSelectLast(_ textField: ArrowKeyableTextField)

    func arrowKeyableTextFieldSelectPrevious(_ textField: ArrowKeyableTextField)
    func arrowKeyableTextFieldSelectNext(_ textField: ArrowKeyableTextField)

    func arrowKeyableTextFieldExpandSelectionToFirst(_ textField: ArrowKeyableTextField)
    func arrowKeyableTextFieldExpandSelectionToLast(_ textField: ArrowKeyableTextField)

    func arrowKeyableTextFieldExpandSelectionToPrevious(_ textField: ArrowKeyableTextField)
    func arrowKeyableTextFieldExpandSelectionToNext(_ textField: ArrowKeyableTextField)
}

class ArrowKeyableTextField: AutoGrowingTextField, NSTextViewDelegate {

    @IBOutlet weak var arrowKeyableDelegate: ArrowKeyableTextFieldDelegate?

    // MARK: Movement via arrow keys from the field editor

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if doMovementCommand(commandSelector: commandSelector) {
            return true
        }
        return self.delegate?.control?(self, textView: textView, doCommandBy: commandSelector)
            ?? false
    }

    private func doMovementCommand(commandSelector: Selector) -> Bool {
        guard let delegate = self.arrowKeyableDelegate else { return false }

        switch commandSelector {
        case #selector(NSResponder.insertNewline(_:)),
             #selector(NSResponder.insertLineBreak(_:)),
             #selector(NSResponder.insertNewlineIgnoringFieldEditor(_:)):

            delegate.arrowKeyableTextFieldDidCommit(self)
            return true

        // MARK: Arrow Keys

        case #selector(NSResponder.moveUp(_:)):
            delegate.arrowKeyableTextFieldSelectPrevious(self)
            return true

        case #selector(NSResponder.moveDown(_:)):
            delegate.arrowKeyableTextFieldSelectNext(self)
            return true

        // MARK: Command+Arrow Keys

        case #selector(NSResponder.moveToBeginningOfDocument(_:)):
            delegate.arrowKeyableTextFieldSelectFirst(self)
            return true

        case #selector(NSResponder.moveToEndOfDocument(_:)):
            delegate.arrowKeyableTextFieldSelectLast(self)
            return true


        // MARK: Shift+Arrow Keys

        case #selector(NSResponder.moveToBeginningOfDocumentAndModifySelection(_:)),
             #selector(NSResponder.moveToBeginningOfParagraphAndModifySelection(_:)):
            delegate.arrowKeyableTextFieldExpandSelectionToFirst(self)
            return true

        case #selector(NSResponder.moveUpAndModifySelection(_:)):
            delegate.arrowKeyableTextFieldExpandSelectionToPrevious(self)
            return true

        case #selector(NSResponder.moveDownAndModifySelection(_:)):
            delegate.arrowKeyableTextFieldExpandSelectionToNext(self)
            return true

        case #selector(NSResponder.moveToEndOfDocumentAndModifySelection(_:)),
             #selector(NSResponder.moveToEndOfParagraphAndModifySelection(_:)):
            delegate.arrowKeyableTextFieldExpandSelectionToLast(self)
            return true

        default:
            return false
        }
    }
}

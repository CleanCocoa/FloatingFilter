//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

protocol FilterChangeDelegate: AnyObject {
    func filterStringDidChange(string: String)
}

class FilterViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var placeholderLabel: NSTextField!
    @IBOutlet weak var filterTextField: ArrowKeyableTextField!
    @IBOutlet weak var returnLabel: NSTextField!

    weak var filterChangeDelegate: FilterChangeDelegate?

    var placeholderText: String? {
        didSet {
            guard isViewLoaded else { return }
            self.placeholderLabel.stringValue = self.placeholderText ?? ""
        }
    }

    override func supplementalTarget(forAction action: Selector, sender: Any?) -> Any? {
        switch action {
        case #selector(NSWindow.performClose(_:)):
            return self.view.window?.windowController
        default:
            return super.supplementalTarget(forAction: action, sender: sender)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeholderLabel.stringValue = self.placeholderText ?? ""
        showPlaceholderLabelOnEmptyFilter()
        changeReturnLabelVisibility(selectionIsEmpty: true)
    }

    override func insertText(_ insertString: Any) {
        filterTextField.insertText(insertString)
    }
    
    // MARK: Update for live typing

    func controlTextDidChange(_ obj: Notification) {
        showPlaceholderLabelOnEmptyFilter()
        forwardFilterChange()
    }

    private func showPlaceholderLabelOnEmptyFilter() {
        placeholderLabel.isHidden = !filterTextField.stringValue.isEmpty
    }

    func changeReturnLabelVisibility(selectionIsEmpty: Bool) {
        returnLabel.isHidden = selectionIsEmpty
    }

    private func forwardFilterChange() {
        filterChangeDelegate?.filterStringDidChange(string: filterTextField.stringValue)
    }
}

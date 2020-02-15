//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

protocol FilterChangeDelegate: class {
    func filterStringDidChange(string: String)
}

class FilterViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var placeholderLabel: NSTextField!
    @IBOutlet weak var filterTextField: NSTextField!

    weak var filterChangeDelegate: FilterChangeDelegate?

    var placeholderText: String? {
        didSet {
            guard isViewLoaded else { return }
            self.placeholderLabel.stringValue = self.placeholderText ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeholderLabel.stringValue = self.placeholderText ?? ""
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

    private func forwardFilterChange() {
        filterChangeDelegate?.filterStringDidChange(string: filterTextField.stringValue)
    }
}

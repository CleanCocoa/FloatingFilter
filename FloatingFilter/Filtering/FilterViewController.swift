//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class FilterViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var placeholderLabel: NSTextField!
    @IBOutlet weak var filterTextField: NSTextField!

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

    func controlTextDidChange(_ obj: Notification) {
        showPlaceholderLabelOnEmptyFilter()
    }

    private func showPlaceholderLabelOnEmptyFilter() {
        placeholderLabel.isHidden = !filterTextField.stringValue.isEmpty
    }
}

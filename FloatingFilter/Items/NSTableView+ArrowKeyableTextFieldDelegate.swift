//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

extension NSTableView: ArrowKeyableTextFieldDelegate {
    private var minSelectedRowIndex: Int {
        return selectedRowIndexes.min() ?? 0
    }

    private var maxSelectedRowIndex: Int {
        return selectedRowIndexes.max()
            ?? max(0, numberOfRows - 1)
    }

    private var lastRowIndex: Int {
        return max(numberOfRows - 1, 0)
    }

    private func selectRowIndex(_ index: Int, byExtendingSelection: Bool = false) {
        selectRowIndexes([index], byExtendingSelection: byExtendingSelection)
    }

    func arrowKeyableTextFieldDidCommit(_ textField: ArrowKeyableTextField) {
        self.sendDoubleAction()
    }

    func arrowKeyableTextFieldSelectFirst(_ textField: ArrowKeyableTextField) {
        selectRowIndex(0)
    }

    func arrowKeyableTextFieldSelectLast(_ textField: ArrowKeyableTextField) {
        selectRowIndex(lastRowIndex)
    }

    func arrowKeyableTextFieldSelectPrevious(_ textField: ArrowKeyableTextField) {
        selectRowIndex(max(0, minSelectedRowIndex - 1))
    }

    func arrowKeyableTextFieldSelectNext(_ textField: ArrowKeyableTextField) {
        selectRowIndex(min(lastRowIndex, maxSelectedRowIndex + 1))
    }

    func arrowKeyableTextFieldExpandSelectionToFirst(_ textField: ArrowKeyableTextField) {
        selectRowIndexes([0], byExtendingSelection: true)
    }

    func arrowKeyableTextFieldExpandSelectionToLast(_ textField: ArrowKeyableTextField) {
        selectRowIndexes([lastRowIndex], byExtendingSelection: true)
    }

    func arrowKeyableTextFieldExpandSelectionToPrevious(_ textField: ArrowKeyableTextField) {
        selectRowIndex(max(0, minSelectedRowIndex - 1), byExtendingSelection: true)
    }

    func arrowKeyableTextFieldExpandSelectionToNext(_ textField: ArrowKeyableTextField) {
        selectRowIndex(min(lastRowIndex, maxSelectedRowIndex + 1), byExtendingSelection: true)
    }
}

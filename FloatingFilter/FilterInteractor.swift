//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol FilteredItemView {
    func showItems(_ items: [Item])
}

class FilterInteractor {
    struct State {
        var allItems: [Item]
        var filterPhrase: String
    }

    private var state: State {
        didSet {
            self.view.showItems(state.filteredItems)
        }
    }

    let view: FilteredItemView

    init(view: FilteredItemView) {
        self.view = view
        self.state = State(allItems: [], filterPhrase: "")
    }
}

// MARK: Item presentation

extension FilterInteractor {
    func showItems(_ items: [Item]) {
        self.state.allItems = items
    }
}

// MARK: Filtering

extension FilterInteractor: FilterChangeDelegate {
    func filterStringDidChange(string: String) {
        self.state.filterPhrase = string
    }
}

extension FilterInteractor.State {
    fileprivate var filteredItems: [Item] {
        guard !filterPhrase.isEmpty else { return allItems }
        let normalizedFilterPhrase = self.filterPhrase.lowercased()
        return allItems.filter { $0.normalizedTitle.contains(normalizedFilterPhrase) }
    }
}

extension Item {
    fileprivate var normalizedTitle: String {
        return self.title.lowercased()
    }
}

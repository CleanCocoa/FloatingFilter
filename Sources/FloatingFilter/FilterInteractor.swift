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
            self.view.showItems(state.filteredItems(filter: filter))
        }
    }

    let view: FilteredItemView
    let filter: ItemFilter

    init(
        view: FilteredItemView,
        filter: @escaping ItemFilter
    ) {
        self.view = view
        self.filter = filter
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
    fileprivate func filteredItems(filter: ItemFilter) -> [Item] {
        guard !filterPhrase.isEmpty else { return allItems }
        return filter(filterPhrase, allItems)
    }
}

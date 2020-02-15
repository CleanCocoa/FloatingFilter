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
        return allItems.sortedByNormalizedFuzzyMatch(pattern: self.filterPhrase)
    }
}

extension Sequence where Iterator.Element == Item {
    fileprivate func sortedByNormalizedFuzzyMatch(pattern: String) -> [Element] {
        // These magic numbers are totally experimental
        let fuzziness = 0.3
        let threshold = 0.4
        
        return self
            .map { (element: $0, score: $0.title.score(word: pattern, fuzziness: fuzziness)) }
            .filter { $0.score > threshold }
            .sorted(by: { $0.score > $1.score })
            .map { $0.element }
    }
}

extension Item {
    fileprivate var normalizedTitle: String {
        return self.title.lowercased()
    }
}

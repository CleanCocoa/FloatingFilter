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
        let normalizedPattern = pattern.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        var result: [Element] = []
        var indexesAdded: [Int] = []

        // Include and weigh results from a threshold of 1/10 up to 1/3. (Rather strict.)
        for iteration in (1...3) {
            let options = FuzzyMatchOptions(threshold: Double(Double(iteration) / Double(10)),
                                            distance: FuzzyMatchingOptionsDefaultValues.distance.rawValue)
            for (index, element) in self.enumerated() {
                if !indexesAdded.contains(index) {
                    if let _ = element.normalizedTitle.fuzzyMatchPattern(normalizedPattern, loc: nil, options: options) {
                        result.append(element)
                        indexesAdded.append(index)
                    }
                }
            }
        }

        return result
    }
}

extension Item {
    fileprivate var normalizedTitle: String {
        return self.title.lowercased()
    }
}

extension Collection {
    @inlinable
    func indexed() -> [(index: Index, element: Element)] {
        zip(indices, self)
            .map { (index: $0, element: $1) }
    }
}

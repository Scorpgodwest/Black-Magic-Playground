import Foundation
import Combine

class CollectionViewModel: ObservableObject {
    @Published var user: User
    @Published var filteredCards: [Card] = []
    @Published var selectedRarity: CardRarity?
    @Published var selectedColor: String?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case rarity = "Rarity"
        case price = "Price"
        case type = "Type"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        setupBindings()
        applyFilters()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest4(
            user.$collection,
            $selectedRarity,
            $selectedColor,
            $searchText
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            self?.applyFilters()
        }
        .store(in: &cancellables)
        
        $sortOption
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func applyFilters() {
        var cards = user.collection
        
        // Apply rarity filter
        if let rarity = selectedRarity {
            cards = cards.filter { $0.rarity == rarity }
        }
        
        // Apply color filter
        if let color = selectedColor, !color.isEmpty {
            cards = cards.filter { $0.colors.contains(color) }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            cards = cards.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.type.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sorting
        switch sortOption {
        case .name:
            cards.sort { $0.name < $1.name }
        case .rarity:
            cards.sort { $0.rarity.rawValue < $1.rarity.rawValue }
        case .price:
            cards.sort { $0.price > $1.price }
        case .type:
            cards.sort { $0.type < $1.type }
        }
        
        filteredCards = cards
    }
    
    func sellCard(_ card: Card) {
        user.sellCard(card)
    }
    
    func clearFilters() {
        selectedRarity = nil
        selectedColor = nil
        searchText = ""
    }
    
    func getTotalCollectionValue() -> Double {
        return user.collection.reduce(0) { $0 + $1.price }
    }
}
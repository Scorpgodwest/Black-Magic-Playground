import Foundation
import Combine

class BoosterOpeningViewModel: ObservableObject {
    @Published var user: User
    @Published var currentBoosterPack: BoosterPack?
    @Published var isOpening = false
    @Published var selectedCards: Set<String> = []
    @Published var showingResults = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
    }
    
    func openBooster(_ booster: Booster) {
        isOpening = true
        
        // Simulate opening animation delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentBoosterPack = self.user.openBooster(booster)
            self.isOpening = false
            self.showingResults = true
        }
    }
    
    func toggleCardSelection(_ cardId: String) {
        if selectedCards.contains(cardId) {
            selectedCards.remove(cardId)
        } else {
            selectedCards.insert(cardId)
        }
    }
    
    func isCardSelected(_ cardId: String) -> Bool {
        return selectedCards.contains(cardId)
    }
    
    func sellSelectedCards() {
        guard let boosterPack = currentBoosterPack else { return }
        
        let cardsToSell = boosterPack.cards.filter { selectedCards.contains($0.id) }
        let cardsToKeep = boosterPack.cards.filter { !selectedCards.contains($0.id) }
        
        user.sellCards(cardsToSell)
        user.addToCollection(cardsToKeep)
        
        resetState()
    }
    
    func keepAllCards() {
        guard let boosterPack = currentBoosterPack else { return }
        user.addToCollection(boosterPack.cards)
        resetState()
    }
    
    func sellAllCards() {
        guard let boosterPack = currentBoosterPack else { return }
        user.sellCards(boosterPack.cards)
        resetState()
    }
    
    private func resetState() {
        currentBoosterPack = nil
        selectedCards.removeAll()
        showingResults = false
    }
    
    func getSelectedCardsValue() -> Double {
        guard let boosterPack = currentBoosterPack else { return 0 }
        return boosterPack.cards
            .filter { selectedCards.contains($0.id) }
            .reduce(0) { $0 + $1.price }
    }
}
import Foundation

class User: ObservableObject {
    @Published var currency: Int
    @Published var collection: [Card]
    @Published var ownedBoosters: [Booster]
    @Published var lastDailyReward: Date?
    
    init() {
        self.currency = 1000 // Starting currency
        self.collection = []
        self.ownedBoosters = []
        self.lastDailyReward = nil
    }
    
    func canClaimDailyReward() -> Bool {
        guard let lastReward = lastDailyReward else { return true }
        return Calendar.current.dateInterval(of: .day, for: Date()) != Calendar.current.dateInterval(of: .day, for: lastReward)
    }
    
    func claimDailyReward() -> (currency: Int, card: Card?) {
        guard canClaimDailyReward() else { return (0, nil) }
        
        lastDailyReward = Date()
        let currencyReward = Int.random(in: 50...150)
        currency += currencyReward
        
        // Generate random card as daily reward
        let randomCard = CardGenerator.shared.generateRandomCard()
        collection.append(randomCard)
        
        return (currencyReward, randomCard)
    }
    
    func buyBooster(_ booster: Booster) -> Bool {
        guard currency >= booster.price else { return false }
        currency -= booster.price
        ownedBoosters.append(booster)
        return true
    }
    
    func openBooster(_ booster: Booster) -> BoosterPack? {
        guard let index = ownedBoosters.firstIndex(where: { $0.id == booster.id }) else { return nil }
        ownedBoosters.remove(at: index)
        
        let cards = CardGenerator.shared.generateBoosterPack(for: booster)
        return BoosterPack(booster: booster, cards: cards)
    }
    
    func addToCollection(_ cards: [Card]) {
        collection.append(contentsOf: cards)
    }
    
    func sellCard(_ card: Card) {
        if let index = collection.firstIndex(where: { $0.id == card.id }) {
            collection.remove(at: index)
            currency += Int(card.price)
        }
    }
    
    func sellCards(_ cards: [Card]) {
        for card in cards {
            sellCard(card)
        }
    }
}
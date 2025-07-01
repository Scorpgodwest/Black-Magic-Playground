import Foundation

struct Booster: Codable, Identifiable {
    let id: String
    let name: String
    let setCode: String
    let setName: String
    let price: Int
    let cardCount: Int
    let rareCount: Int
    let uncommonCount: Int
    let commonCount: Int
    let imageUrl: String?
    
    init(id: String = UUID().uuidString, name: String, setCode: String, setName: String, price: Int, cardCount: Int = 15, rareCount: Int = 1, uncommonCount: Int = 3, commonCount: Int = 11, imageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.setCode = setCode
        self.setName = setName
        self.price = price
        self.cardCount = cardCount
        self.rareCount = rareCount
        self.uncommonCount = uncommonCount
        self.commonCount = commonCount
        self.imageUrl = imageUrl
    }
}

struct BoosterPack {
    let booster: Booster
    let cards: [Card]
    let totalValue: Double
    
    init(booster: Booster, cards: [Card]) {
        self.booster = booster
        self.cards = cards
        self.totalValue = cards.reduce(0) { $0 + $1.price }
    }
}
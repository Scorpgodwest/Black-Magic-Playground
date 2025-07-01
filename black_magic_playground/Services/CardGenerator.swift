import Foundation

class CardGenerator {
    static let shared = CardGenerator()
    
    private let sampleCards: [Card] = [
        // Sample cards for demonstration
        Card(id: "1", name: "Lightning Bolt", manaCost: "{R}", type: "Instant", rarity: .common, colors: ["R"], imageUrl: nil, price: 0.25, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "2", name: "Counterspell", manaCost: "{U}{U}", type: "Instant", rarity: .uncommon, colors: ["U"], imageUrl: nil, price: 1.50, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "3", name: "Serra Angel", manaCost: "{3}{W}{W}", type: "Creature — Angel", rarity: .rare, colors: ["W"], imageUrl: nil, price: 5.00, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "4", name: "Jace, the Mind Sculptor", manaCost: "{2}{U}{U}", type: "Legendary Planeswalker — Jace", rarity: .mythic, colors: ["U"], imageUrl: nil, price: 85.00, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "5", name: "Forest", manaCost: nil, type: "Basic Land — Forest", rarity: .common, colors: ["G"], imageUrl: nil, price: 0.10, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "6", name: "Shock", manaCost: "{R}", type: "Instant", rarity: .common, colors: ["R"], imageUrl: nil, price: 0.15, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "7", name: "Llanowar Elves", manaCost: "{G}", type: "Creature — Elf Druid", rarity: .common, colors: ["G"], imageUrl: nil, price: 0.50, setCode: "M21", setName: "Core Set 2021"),
        Card(id: "8", name: "Wrath of God", manaCost: "{2}{W}{W}", type: "Sorcery", rarity: .rare, colors: ["W"], imageUrl: nil, price: 8.00, setCode: "M21", setName: "Core Set 2021")
    ]
    
    private init() {}
    
    func generateBoosterPack(for booster: Booster) -> [Card] {
        var cards: [Card] = []
        
        // Generate commons
        for _ in 0..<booster.commonCount {
            cards.append(generateRandomCard(rarity: .common, setCode: booster.setCode, setName: booster.setName))
        }
        
        // Generate uncommons
        for _ in 0..<booster.uncommonCount {
            cards.append(generateRandomCard(rarity: .uncommon, setCode: booster.setCode, setName: booster.setName))
        }
        
        // Generate rares (with chance for mythic)
        for _ in 0..<booster.rareCount {
            let rarity: CardRarity = Double.random(in: 0...1) < 0.125 ? .mythic : .rare // 1/8 chance for mythic
            cards.append(generateRandomCard(rarity: rarity, setCode: booster.setCode, setName: booster.setName))
        }
        
        return cards
    }
    
    func generateRandomCard(rarity: CardRarity? = nil, setCode: String = "M21", setName: String = "Core Set 2021") -> Card {
        let targetRarity = rarity ?? CardRarity.allCases.randomElement()!
        let baseCards = sampleCards.filter { $0.rarity == targetRarity }
        let baseCard = baseCards.randomElement() ?? sampleCards.first!
        
        // Create a new card with random variations
        let cardNames = generateCardNames(for: targetRarity)
        let randomName = cardNames.randomElement() ?? baseCard.name
        
        return Card(
            id: UUID().uuidString,
            name: randomName,
            manaCost: baseCard.manaCost,
            type: baseCard.type,
            rarity: targetRarity,
            colors: baseCard.colors,
            imageUrl: baseCard.imageUrl,
            price: generatePrice(for: targetRarity),
            setCode: setCode,
            setName: setName
        )
    }
    
    private func generateCardNames(for rarity: CardRarity) -> [String] {
        switch rarity {
        case .common:
            return ["Lightning Bolt", "Shock", "Forest", "Plains", "Island", "Mountain", "Swamp", "Llanowar Elves", "Grizzly Bears", "Cancel"]
        case .uncommon:
            return ["Counterspell", "Lightning Strike", "Essence Scatter", "Negate", "Divination", "Sign in Blood", "Rampant Growth", "Naturalize"]
        case .rare:
            return ["Serra Angel", "Wrath of God", "Demonic Tutor", "Time Walk", "Ancestral Recall", "Black Lotus", "Mox Ruby", "Sol Ring"]
        case .mythic:
            return ["Jace, the Mind Sculptor", "Liliana of the Veil", "Chandra, Torch of Defiance", "Gideon Jura", "Elspeth, Knight-Errant", "Nicol Bolas, Planeswalker"]
        }
    }
    
    private func generatePrice(for rarity: CardRarity) -> Double {
        switch rarity {
        case .common:
            return Double.random(in: 0.05...0.50)
        case .uncommon:
            return Double.random(in: 0.25...3.00)
        case .rare:
            return Double.random(in: 1.00...15.00)
        case .mythic:
            return Double.random(in: 5.00...100.00)
        }
    }
}
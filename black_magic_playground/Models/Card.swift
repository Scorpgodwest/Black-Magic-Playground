import Foundation
import UIKit
struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let manaCost: String?
    let type: String
    let rarity: CardRarity
    let colors: [String]
    let imageUrl: String?
    let price: Double
    let setCode: String
    let setName: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, rarity, colors, price
        case manaCost = "mana_cost"
        case imageUrl = "image_uris"
        case setCode = "set"
        case setName = "set_name"
    }
}

enum CardRarity: String, CaseIterable, Codable {
    case common = "common"
    case uncommon = "uncommon"
    case rare = "rare"
    case mythic = "mythic"
    
    var displayName: String {
        switch self {
        case .common: return "Common"
        case .uncommon: return "Uncommon"
        case .rare: return "Rare"
        case .mythic: return "Mythic Rare"
        }
    }
    
    var color: UIColor {
        switch self {
        case .common: return .systemGray
        case .uncommon: return .systemBlue
        case .rare: return .systemYellow
        case .mythic: return .systemOrange
        }
    }
}

enum CardColor: String, CaseIterable {
    case white = "W"
    case blue = "U"
    case black = "B"
    case red = "R"
    case green = "G"
    case colorless = "C"
    
    var displayName: String {
        switch self {
        case .white: return "White"
        case .blue: return "Blue"
        case .black: return "Black"
        case .red: return "Red"
        case .green: return "Green"
        case .colorless: return "Colorless"
        }
    }
}

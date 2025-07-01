import Foundation

class BoosterService {
    static let shared = BoosterService()
    
    private init() {}
    
    func getAvailableBoosters() -> [Booster] {
        return [
            Booster(
                name: "Core Set 2021 Booster Pack",
                setCode: "M21",
                setName: "Core Set 2021",
                price: 150
            ),
            Booster(
                name: "Zendikar Rising Booster Pack",
                setCode: "ZNR",
                setName: "Zendikar Rising",
                price: 180
            ),
            Booster(
                name: "Kaldheim Booster Pack",
                setCode: "KHM",
                setName: "Kaldheim",
                price: 200
            ),
            Booster(
                name: "Premium Collector Booster",
                setCode: "M21",
                setName: "Core Set 2021",
                price: 500,
                cardCount: 15,
                rareCount: 3,
                uncommonCount: 5,
                commonCount: 7
            )
        ]
    }
}
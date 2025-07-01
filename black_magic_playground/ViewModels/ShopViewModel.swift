import Foundation
import Combine

class ShopViewModel: ObservableObject {
    @Published var availableBoosters: [Booster] = []
    @Published var user: User
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        loadBoosters()
    }
    
    func loadBoosters() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.availableBoosters = BoosterService.shared.getAvailableBoosters()
            self.isLoading = false
        }
    }
    
    func buyBooster(_ booster: Booster) -> Bool {
        guard user.currency >= booster.price else {
            errorMessage = "Insufficient currency!"
            return false
        }
        
        let success = user.buyBooster(booster)
        if success {
            errorMessage = nil
        } else {
            errorMessage = "Failed to purchase booster"
        }
        return success
    }
    
    func canAfford(_ booster: Booster) -> Bool {
        return user.currency >= booster.price
    }
}
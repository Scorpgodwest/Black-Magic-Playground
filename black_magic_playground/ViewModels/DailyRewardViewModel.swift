import Foundation
import Combine

class DailyRewardViewModel: ObservableObject {
    @Published var user: User
    @Published var canClaim: Bool = false
    @Published var isClaimingReward = false
    @Published var lastReward: (currency: Int, card: Card?)?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        checkRewardAvailability()
        
        // Check every minute if daily reward becomes available
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkRewardAvailability()
            }
            .store(in: &cancellables)
    }
    
    func checkRewardAvailability() {
        canClaim = user.canClaimDailyReward()
    }
    
    func claimDailyReward() {
        guard canClaim else { return }
        
        isClaimingReward = true
        
        // Simulate claim delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.lastReward = self.user.claimDailyReward()
            self.isClaimingReward = false
            self.checkRewardAvailability()
        }
    }
    
    func getTimeUntilNextReward() -> String {
        guard let lastReward = user.lastDailyReward else {
            return "Available now!"
        }
        
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: lastReward)!
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        let now = Date()
        
        if now >= startOfTomorrow {
            return "Available now!"
        }
        
        let timeInterval = startOfTomorrow.timeIntervalSince(now)
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        
        return "\(hours)h \(minutes)m"
    }
}

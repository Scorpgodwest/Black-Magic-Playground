import UIKit

class MainTabBarController: UITabBarController {
    
    private let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupViewControllers() {
        let shopVC = ShopViewController(user: user)
        let shopNav = UINavigationController(rootViewController: shopVC)
        shopNav.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "bag"), tag: 0)
        
        let collectionVC = CollectionViewController(user: user)
        let collectionNav = UINavigationController(rootViewController: collectionVC)
        collectionNav.tabBarItem = UITabBarItem(title: "Collection", image: UIImage(systemName: "rectangle.stack"), tag: 1)
        
        let boostersVC = MyBoostersViewController(user: user)
        let boostersNav = UINavigationController(rootViewController: boostersVC)
        boostersNav.tabBarItem = UITabBarItem(title: "Boosters", image: UIImage(systemName: "gift"), tag: 2)
        
        let rewardsVC = DailyRewardViewController(user: user)
        let rewardsNav = UINavigationController(rootViewController: rewardsVC)
        rewardsNav.tabBarItem = UITabBarItem(title: "Rewards", image: UIImage(systemName: "star"), tag: 3)
        
        viewControllers = [shopNav, collectionNav, boostersNav, rewardsNav]
    }
}
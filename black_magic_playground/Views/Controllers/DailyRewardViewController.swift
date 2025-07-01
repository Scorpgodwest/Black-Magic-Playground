import UIKit
import Combine

class DailyRewardViewController: UIViewController {
    
    private let viewModel: DailyRewardViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Rewards"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var claimButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Claim Reward", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(claimRewardTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rewardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gift.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(user: User) {
        self.viewModel = DailyRewardViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currencyLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(rewardImageView)
        view.addSubview(statusLabel)
        view.addSubview(claimButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            rewardImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            rewardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardImageView.widthAnchor.constraint(equalToConstant: 100),
            rewardImageView.heightAnchor.constraint(equalToConstant: 100),
            
            statusLabel.topAnchor.constraint(equalTo: rewardImageView.bottomAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            claimButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            claimButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            claimButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            claimButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currencyLabel.text = "💰 \(user.currency)"
            }
            .store(in: &cancellables)
        
        viewModel.$canClaim
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canClaim in
                self?.updateUI(canClaim: canClaim)
            }
            .store(in: &cancellables)
        
        viewModel.$isClaimingReward
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isClaiming in
                self?.claimButton.isEnabled = !isClaiming
                self?.claimButton.setTitle(isClaiming ? "Claiming..." : "Claim Reward", for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$lastReward
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reward in
                if let reward = reward {
                    self?.showRewardAlert(currency: reward.currency, card: reward.card)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(canClaim: Bool) {
        claimButton.isEnabled = canClaim
        claimButton.backgroundColor = canClaim ? .systemBlue : .systemGray
        
        if canClaim {
            statusLabel.text = "Your daily reward is ready to claim!\nGet coins and a random card."
            statusLabel.textColor = .label
        } else {
            let timeUntilNext = viewModel.getTimeUntilNextReward()
            statusLabel.text = "Next reward available in:\n\(timeUntilNext)"
            statusLabel.textColor = .systemGray
        }
    }
    
    @objc private func claimRewardTapped() {
        viewModel.claimDailyReward()
    }
    
    private func showRewardAlert(currency: Int, card: Card?) {
        var message = "You received \(currency) coins!"
        if let card = card {
            message += "\n\nBonus card: \(card.name)"
        }
        
        let alert = UIAlertController(
            title: "Reward Claimed!",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
        present(alert, animated: true)
    }
}
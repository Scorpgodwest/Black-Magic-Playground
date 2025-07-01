import UIKit
import Combine

class MyBoostersViewController: UIViewController {
    
    private let viewModel: BoosterOpeningViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(BoosterCell.self, forCellReuseIdentifier: BoosterCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No boosters owned\nVisit the shop to buy some!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(user: User) {
        self.viewModel = BoosterOpeningViewModel(user: user)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func setupUI() {
        title = "My Boosters"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)
        
        viewModel.$showingResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showingResults in
                if showingResults {
                    self?.presentBoosterResults()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !viewModel.user.ownedBoosters.isEmpty
        tableView.isHidden = viewModel.user.ownedBoosters.isEmpty
    }
    
    private func presentBoosterResults() {
        guard let boosterPack = viewModel.currentBoosterPack else { return }
        
        let resultsVC = BoosterResultsViewController(
            boosterPack: boosterPack,
            viewModel: viewModel
        )
        let navController = UINavigationController(rootViewController: resultsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyBoostersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.user.ownedBoosters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoosterCell.identifier, for: indexPath) as! BoosterCell
        let booster = viewModel.user.ownedBoosters[indexPath.row]
        cell.configure(with: booster, canAfford: true)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let booster = viewModel.user.ownedBoosters[indexPath.row]
        
        let alert = UIAlertController(
            title: "Open Booster",
            message: "Open \(booster.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open", style: .default) { [weak self] _ in
            self?.viewModel.openBooster(booster)
        })
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
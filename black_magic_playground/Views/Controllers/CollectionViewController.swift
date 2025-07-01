import UIKit
import Combine

class CollectionViewController: UIViewController {
    
    private let viewModel: CollectionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search cards..."
        return controller
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(showFilters)
        )
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 30) / 2, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    init(user: User) {
        self.viewModel = CollectionViewModel(user: user)
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
        title = "Collection"
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(statsLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            statsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$filteredCards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cards in
                self?.collectionView.reloadData()
                self?.updateStatsLabel()
            }
            .store(in: &cancellables)
        
        viewModel.$searchText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText in
                if self?.searchController.searchBar.text != searchText {
                    self?.searchController.searchBar.text = searchText
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateStatsLabel() {
        let totalCards = viewModel.filteredCards.count
        let totalValue = viewModel.getTotalCollectionValue()
        statsLabel.text = "\(totalCards) cards • Total value: $\(String(format: "%.2f", totalValue))"
    }
    
    @objc private func showFilters() {
        let filterVC = FilterViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: filterVC)
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as! CardCell
        let card = viewModel.filteredCards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = viewModel.filteredCards[indexPath.item]
        
        let alert = UIAlertController(
            title: card.name,
            message: "Sell this card for \(Int(card.price)) coins?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sell", style: .destructive) { [weak self] _ in
            self?.viewModel.sellCard(card)
        })
        
        present(alert, animated: true)
    }
}
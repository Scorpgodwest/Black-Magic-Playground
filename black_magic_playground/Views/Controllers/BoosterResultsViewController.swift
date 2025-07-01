import UIKit
import Combine

class BoosterResultsViewController: UIViewController {
    
    private let boosterPack: BoosterPack
    private let viewModel: BoosterOpeningViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Booster Opened!"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(SelectableCardCell.self, forCellWithReuseIdentifier: SelectableCardCell.identifier)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var sellSelectedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sell Selected", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sellSelectedTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var keepAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Keep All", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(keepAllTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sellAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sell All", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sellAllTapped), for: .touchUpInside)
        return button
    }()
    
    init(boosterPack: BoosterPack, viewModel: BoosterOpeningViewModel) {
        self.boosterPack = boosterPack
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        updateValueLabel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Cards Revealed"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
        
        actionStackView.addArrangedSubview(sellSelectedButton)
        actionStackView.addArrangedSubview(keepAllButton)
        actionStackView.addArrangedSubview(sellAllButton)
        
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        view.addSubview(collectionView)
        view.addSubview(actionStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -20),
            
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBindings() {
        viewModel.$selectedCards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.updateValueLabel()
            }
            .store(in: &cancellables)
    }
    
    private func updateValueLabel() {
        let totalValue = boosterPack.totalValue
        let selectedValue = viewModel.getSelectedCardsValue()
        valueLabel.text = "Total value: $\(String(format: "%.2f", totalValue)) • Selected: $\(String(format: "%.2f", selectedValue))"
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sellSelectedTapped() {
        viewModel.sellSelectedCards()
        dismiss(animated: true)
    }
    
    @objc private func keepAllTapped() {
        viewModel.keepAllCards()
        dismiss(animated: true)
    }
    
    @objc private func sellAllTapped() {
        viewModel.sellAllCards()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension BoosterResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boosterPack.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectableCardCell.identifier, for: indexPath) as! SelectableCardCell
        let card = boosterPack.cards[indexPath.item]
        let isSelected = viewModel.isCardSelected(card.id)
        cell.configure(with: card, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = boosterPack.cards[indexPath.item]
        viewModel.toggleCardSelection(card.id)
    }
}
//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class ResultViewController: UIViewController {
    private let userDefaults = UserDefaultsManager()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningPrimary
        label.textAlignment = .left
        label.font = .capB
        return label
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.spacing = 8
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        
        return view
    }()
    private lazy var sortButtons: [UIButton] = {
        var array: [UIButton] = []
        SortBy.allCases.forEach {
            let button = CapsuleButton(title: $0.title, tag: $0.rawValue)
            button.isSelect = $0.rawValue == 0
            button.addTarget(self, action: #selector(sortButtonDidTap(_: )), for: .touchUpInside)
            array.append(button)
        }
        
        return array
    }()
    private lazy var resultCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        
        collection.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        return collection
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 16
        let padding: CGFloat = 16
        let width = (screenWidth - inset * 2 - padding ) / 2
        
        layout.itemSize = CGSize(width: width, height: width * 1.8)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        return layout
    }()
    
    private var searchResult: SearchResponse = SearchResponse(total: 0, start: 0, display: 30, items: []) {
        willSet {
            if newValue.total == 0 {
                showOneBtnAlert(title: "검색 결과가 없습니다") { [weak self] in
                    guard let self else { return }
                    navigationController?.popViewController(animated: true)
                }
            } else {
                resultCollectionView.reloadData()
            }
        }
    }
    private lazy var sort: SortBy = .accuracy {
        didSet {
            start = 1
            requestSearchResult(target)
        }
    }
    private var likeList: [String] {
        willSet {
            userDefaults.likeList = newValue
        }
    }
    
    private let target: String
    private var start = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        
        setNavigation()
        setHierachy()
        setConstraints()
    }
    
    init(searchTarget target: String) {
        self.target = target
        
        if let list = userDefaults.likeList {
            likeList = list
        } else {
            likeList = []
        }
        
        super.init(nibName: nil, bundle: nil)
        
        requestSearchResult(target)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation() {
        navigationItem.title = target
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    private func setHierachy() {
        [totalCountLabel, stackView, resultCollectionView].forEach {
            view.addSubview($0)
        }
        
        sortButtons.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        totalCountLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(36)
        }
        
        sortButtons.forEach { button in
            button.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
            }
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func requestSearchResult(_ target: String) {
        Network.getSearchResult(target, start: start, sort: sort) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                if start > 1 {
                    searchResult.items += response.items
                } else {
                    searchResult = response
                    totalCountLabel.text = response.total.formatted() + "개의 검색 결과"
                    totalCountLabel.layoutIfNeeded()
                    if response.total > 0 {
                        resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                }
            case .failure(let error):
                showOneBtnAlert(title: "데이터를 읽어오는 데 실패했습니다.", message: "잠시 후 다시 시도해주세요.") { [weak self] in
                    guard let self else { return }
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func sortButtonDidTap(_ sender: CapsuleButton) {
        sortButtons.forEach {
            guard let button = $0 as? CapsuleButton else { return }
            button.isSelect = button == sender
        }
        
        sort = SortBy(rawValue: sender.tag) ?? .accuracy
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        let data = searchResult.items[indexPath.row]
        
        cell.configureCell(data, target: target, isLike: likeList.contains(data.productId))
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeBtnDidTap), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchResult.items[indexPath.row]
        let isContains = likeList.contains(data.productId)
        let nextVC = DetailViewController(productName: data.titleNoneHTML, link: data.link, isLike: isContains)
        
        nextVC.completionHandler = { [weak self] isLike in
            guard let self else { return }
            
            if isContains && !isLike {
                likeList.removeAll { $0 == data.productId }
            } else if !isContains && isLike {
                likeList.append(data.productId)
            }
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func likeBtnDidTap(sender: UIButton) {
        let productId = searchResult.items[sender.tag].productId
        let isContains = likeList.contains(productId)
        
        if isContains {
            likeList.removeAll { $0 == productId }
        } else {
            likeList.append(productId)
        }
        
        resultCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
}

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let count = searchResult.items.count
        
        if indexPaths.contains(where: { $0.row == count - 5 }) {
            start += 30
            requestSearchResult(target)
        }
    }
}

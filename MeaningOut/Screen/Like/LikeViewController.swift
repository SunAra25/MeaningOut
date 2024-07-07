//
//  LikeViewController.swift
//  MeaningOut
//
//  Created by 아라 on 7/7/24.
//

import UIKit
import SnapKit

final class LikeViewController: BaseViewController {
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        return view
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
        layout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 0, right: 16)
        
        return layout
    }()
    private let repository = ProductRepository()
    private lazy var list = repository.fetchLikeList() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = NaviTitle.like.rawValue
    }
    
    override func setHierachy() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell()}
        cell.configureCell(list[indexPath.row])
        return cell
    }
}

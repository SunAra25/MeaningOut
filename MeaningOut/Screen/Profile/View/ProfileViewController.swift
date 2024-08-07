//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    private lazy var viewModel = ProfileViewModel(imageNum)
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView(.user, imageNum: imageNum)
        
        view.layer.cornerRadius = 50
        
        return view
    }()
    private let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .meaningPrimary
        view.layer.cornerRadius = 16
        return view
    }()
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.camera
        view.tintColor = .meaningWhite
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collection.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collection.isScrollEnabled = false
        
        return collection
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let width = UIScreen.main.bounds.width
        let inset: CGFloat = 16
        let padding: CGFloat = 12
        let size = (width - inset * 2 - padding * 3) / 4
        
        layout.itemSize = CGSize(width: size, height: size)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        return layout
    }()
    
    var imageNum: Int
    let navigationTitle: NaviTitle
    var completionHandler: ((Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.inputWillDisappear.value = ()
    }
    
    init(imageNum: Int, title: NaviTitle) {
        self.imageNum = imageNum
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = navigationTitle.rawValue
    }

    override func setHierachy() {
        [profileView, cameraView, collectionView].forEach {
            view.addSubview($0)
        }
        
        cameraView.addSubview(cameraImageView)
    }
    
    override func setConstraints() {
        profileView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.size.equalTo(100)
        }
        
        cameraView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileView)
            make.size.equalTo(32)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(80)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindData() {
        viewModel.outputChangeProfileImage.bind { [weak self] imgNum in
            guard let self, let imgNum else { return }
            imageNum = imgNum
            profileView.changeImage(imgNum)
            collectionView.reloadData()
        }
        
        viewModel.outputPopVC.bind { [weak self] imgNum in
            guard let self, let imgNum else { return }
            completionHandler?(imgNum)
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        let index = indexPath.row
        let radius = cell.bounds.width / 2
        
        cell.configureCell(index, radius: radius, isSelected: index == imageNum)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputNewImageNum.value = indexPath.row
    }
}

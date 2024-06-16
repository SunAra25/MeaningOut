//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/16/24.
//

import UIKit
import SnapKit

#if DEBUG
@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: SettingViewController())
}
#endif

final class SettingViewController: UIViewController {
    private let userDefaults = UserDefaultsManager()
    
    private let profileView: UIView = {
        let view = UIView()
        // TODO: 프로필 수정 뷰로 화면전환
        return view
    }()
    private lazy var profileImageView: ProfileView = {
        let view = ProfileView(.user, imageNum: userDefaults.imageNum)
        view.layer.cornerRadius = 40
        return view
    }()
    private let labelView = UIView()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningBlack
        label.textAlignment = .left
        label.font = .headB
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray2
        label.textAlignment = .left
        label.font = .capM
        return label
    }()
    private let chevronImgaeView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.chevron
        view.tintColor = .meaningBlack
        return view
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        table.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavigation()
        setHierachy()
        setConstraints()
    }

    func setNavigation() {
        navigationItem.title = NaviTitle.setting.rawValue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    func setHierachy() {
        [profileView, tableView].forEach {
            view.addSubview($0)
        }
        
        [profileImageView, labelView, chevronImgaeView].forEach {
            profileView.addSubview($0)
        }
        
        [nicknameLabel, dateLabel].forEach {
            labelView.addSubview($0)
        }
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(80)
        }
        
        labelView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.leading.bottom.equalToSuperview()
        }
        
        chevronImgaeView.snp.makeConstraints { make in
            make.leading.equalTo(labelView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = Setting.allCases[indexPath.row].rawValue
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
            guard let list = userDefaults.likeList else { return cell }
            
            cell.selectionStyle = .none
            cell.configureCell(data, numOfLike: list.count)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as! DefaultTableViewCell
            
            cell.selectionStyle = .none
            cell.configureCell(data)
            return cell
        }
    }
}

//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    let userDefaults = UserDefaultsManager()
    
    private let searchBar = UISearchBar()
    private let emptyView = UIView()
    private let emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.empty
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없어요"
        label.textColor = .meaningBlack
        label.textAlignment = .center
        label.font = .bodyB
        return label
    }()
    private let searchView = UIView()
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.textColor = .meaningBlack
        label.textAlignment = .left
        label.font = .subB
        return label
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("전체 삭제")
        attr.font = UIFont.capM
        
        config.attributedTitle = attr
        config.baseForegroundColor = .meaningPrimary
        
        button.configuration = config
        return button
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .red
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        
        setNavigation()
        setUI()
        setHierachy()
        setConstraints()
    }
    
    func setUI() {
        guard let recentlyList = userDefaults.recentlySearch else {
            emptyView.isHidden = false
            searchView.isHidden = true
            return
        }
        
        emptyView.isHidden = !recentlyList.isEmpty
        searchView.isHidden = recentlyList.isEmpty
    }
    
    func setNavigation() {
        let nickname = userDefaults.nickname
        
        navigationItem.title = nickname + NaviTitle.search.rawValue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    func setHierachy() {
        [searchBar, emptyView, searchView].forEach {
            view.addSubview($0)
        }
        
        [emptyImageView, emptyLabel].forEach {
            emptyView.addSubview($0)
        }
        
        [searchLabel, deleteButton, tableView].forEach {
            searchView.addSubview($0)
        }
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(emptyLabel.snp.top).offset(-12)
            make.height.greaterThanOrEqualTo(200)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.centerY).offset(80)
            make.centerX.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(searchLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

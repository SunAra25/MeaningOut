//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    let userDefaults = UserDefaultsManager()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.tintColor = .meaningBlack
        bar.returnKeyType = .search
        bar.autocorrectionType = .no
        bar.spellCheckingType = .no
        return bar
    }()
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
        button.addTarget(self, action: #selector(deleteAllBtnDidTap), for: .touchUpInside)
        return button
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.separatorStyle = .none
        table.rowHeight = 40
        table.register(RecentlyTableViewCell.self, forCellReuseIdentifier: RecentlyTableViewCell.identifier)
        
        return table
    }()
    
    private var recentlyList: [String] = [] {
        didSet {
            tableView.reloadData()
        }
        
        willSet {
            let newDictionary = Dictionary(uniqueKeysWithValues: zip(newValue, (0..<newValue.count)))
            userDefaults.recentlySearch = newDictionary
            
            tableView.isHidden = newValue.isEmpty
            emptyView.isHidden = !newValue.isEmpty
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setupKeyboardEvent()
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    private func setUI() {
        guard let recentlyList = userDefaults.recentlySearch else {
            emptyView.isHidden = false
            searchView.isHidden = true
            return
        }
        
        emptyView.isHidden = !recentlyList.isEmpty
        searchView.isHidden = recentlyList.isEmpty
        
        let dic = recentlyList.sorted { $0.value < $1.value }
        self.recentlyList = dic.map { $0.key }
    }
    
    override func setNavigation() {
        super.setNavigation()
        let nickname = userDefaults.nickname
        navigationItem.title = nickname + NaviTitle.search.rawValue
    }
    
    override func setHierachy() {
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

    override func setConstraints() {
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
            make.top.equalTo(deleteButton.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    @objc private func deleteAllBtnDidTap() {
        recentlyList.removeAll()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentlyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyTableViewCell.identifier, for: indexPath) as! RecentlyTableViewCell
        let data = recentlyList[indexPath.row]
        
        cell.configureCell(data)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        let target = recentlyList[indexPath.row]
        recentlyList.remove(at: indexPath.row)
        recentlyList.insert(target, at: 0)
        
        let nextVC = ResultViewController(searchTarget: target)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func deleteButtonDidTap(_ sender: UIButton) {
        recentlyList.remove(at: sender.tag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let target = searchBar.text else { return }
        
        if recentlyList.contains(target) {
            recentlyList.removeAll { $0 == target }
        }
        
        recentlyList.insert(target, at: 0)
        
        view.endEditing(true)
        self.searchBar.text = ""
        
        let nextVC = ResultViewController(searchTarget: target)
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension SearchViewController {
    private func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

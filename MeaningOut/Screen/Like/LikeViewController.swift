//
//  LikeViewController.swift
//  MeaningOut
//
//  Created by 아라 on 7/7/24.
//

import UIKit
import SnapKit

final class LikeViewController: BaseViewController {
    private let tableView = {
        let view = UITableView()
        view.backgroundColor = .red
        return view
    }()
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = NaviTitle.like.rawValue
    }
    
    override func setHierachy() {
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//
//  RecentlyTableViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class RecentlyTableViewCell: BaseTableViewCell {
    static let identifier = "RecentlyTableViewCell"
    
    private let clockImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.clock
        view.tintColor = .meaningBlack
        return view
    }()
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningBlack
        label.textAlignment = .left
        label.font = .subM
        return label
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage.xmark
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 13)
        
        button.configuration = config
        button.tintColor = .meaningBlack
        
        return button
    }()
    
    override func setLayout(){
        [clockImageView, searchLabel, deleteButton].forEach {
            contentView.addSubview($0)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(clockImageView.snp.trailing).offset(12)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
    }
    
    func configureCell(_ text: String) {
        searchLabel.text = text
    }
}

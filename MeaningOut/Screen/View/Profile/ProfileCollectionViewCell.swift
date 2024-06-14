//
//  ProfileCollectionViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    private let profileView: ProfileView = {
        let view = ProfileView(width: 1, color: .meaningGray1)
        view.alpha = 0.5
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ name: String) {
        profileView.configureImage(name)
    }
    
    func setLayout() {
        contentView.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(profileView.snp.width)
        }
    }
}

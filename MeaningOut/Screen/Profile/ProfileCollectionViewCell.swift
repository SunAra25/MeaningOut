//
//  ProfileCollectionViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    private let profileView = ProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    override func setLayout() {
        contentView.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(profileView.snp.width)
        }
    }
    
    func configureCell(_ num: Int, radius: CGFloat, isSelected: Bool) {
        profileView.configureView(isSelected ? .selected : .example, imageNum: num)
        profileView.layer.cornerRadius = radius
    }
}

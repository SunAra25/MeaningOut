//
//  ProfileView.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    private let profileImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    convenience init(_ type: ProfileType, imageNum: Int) {
        self.init()
        
        configureView(type, imageNum: imageNum)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ type: ProfileType, imageNum: Int) {
        backgroundColor = .clear
        
        layer.borderWidth = type.borderWidth
        layer.borderColor = type.borderColor?.cgColor
        
        alpha = type.alpha
        
        clipsToBounds = true
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = UIImage(named: "profile_\(imageNum)")
    }
    
    func changeImage(_ imageNum: Int) {
        profileImageView.image = UIImage(named: "profile_\(imageNum)")
    }
    
    private func setLayout() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

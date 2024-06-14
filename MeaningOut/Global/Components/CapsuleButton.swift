//
//  CapsuleButton.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit

class CapsuleButton: UIButton {
    
    init(title: String, tag: Int) {
        super.init(frame: .zero)
        
        configureButton(title: title, tag: tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSelect: Bool = false {
        didSet {
            self.updateButton()
        }
    }
    
    private func configureButton(title: String, tag: Int) {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init(title)
        
        attr.font = UIFont.subM
        
        config.attributedTitle = attr
        configuration = config
        
        layer.cornerRadius = 18
        layer.borderColor = UIColor.meaningGray1?.cgColor
        layer.borderWidth = 1
        
        self.tag = tag
        clipsToBounds = true
    }
    
    func updateButton() {
        var config = configuration ?? UIButton.Configuration.plain()
        config.baseForegroundColor = isSelect ? .meaningWhite : .meaningGray1
        backgroundColor = isSelect ? .meaningGray1 : .meaningWhite
        configuration = config
    }
}


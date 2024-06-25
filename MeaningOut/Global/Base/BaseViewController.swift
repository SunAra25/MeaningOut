//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        
        setNavigation()
        setHierachy()
        setConstraints()
    }
    
    func setNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    func setHierachy() { }
    
    func setConstraints() { }
}

//
//  MainTabBarController.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        tabBar.backgroundColor = .white
        UITabBar.appearance().tintColor = .meaningPrimary
        UITabBar.appearance().unselectedItemTintColor = .meaningBlack
        
        let searchViewContrller = UINavigationController(rootViewController: SearchViewController())
        
        searchViewContrller.tabBarItem = UITabBarItem(title: "검색", image: UIImage.magnifyingglass, tag: 0)
        
        viewControllers = [searchViewContrller]
    }
}

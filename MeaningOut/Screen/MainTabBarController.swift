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

    private func setUI() {
        tabBar.backgroundColor = .white
        UITabBar.appearance().tintColor = .meaningPrimary
        UITabBar.appearance().unselectedItemTintColor = .meaningGray2
        
        let searchViewContrller = UINavigationController(rootViewController: SearchViewController())
        let likeViewController = UINavigationController(rootViewController: LikeViewController())
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        
        searchViewContrller.tabBarItem = UITabBarItem(title: "검색", image: UIImage.magnifyingglass, tag: 0)
        likeViewController.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage.heart, tag: 1)
        settingViewController.tabBarItem = UITabBarItem(title: "설정", image: UIImage.person, tag: 2)
        
        viewControllers = [searchViewContrller, likeViewController, settingViewController]
    }
}

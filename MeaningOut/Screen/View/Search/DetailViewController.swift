//
//  DetailViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import UIKit
import SnapKit
import WebKit

final class DetailViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        if let url = urlLink {
            let request = URLRequest(url: url)
            view.load(request)
        }
        return view
    }()
    private let urlLink: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    init(productName: String, link: String) {
        urlLink = URL(string: link)
        
        super.init(nibName: nil, bundle: nil)
        
        setNavigation(productName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavigation(_ title: String) {
        navigationItem.title = title
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    func setLayout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

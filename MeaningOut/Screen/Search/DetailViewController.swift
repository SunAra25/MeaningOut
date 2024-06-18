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
        view.navigationDelegate = self
        return view
    }()
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let urlLink: URL?
    private var isLike: Bool {
        willSet {
            navigationItem.rightBarButtonItem?.image = newValue ? .likeSelected : .likeUnselected.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var completionHandler: ((Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        setLayout()
    }
    
    init(productName: String, link: String, isLike: Bool) {
        urlLink = URL(string: link)
        self.isLike = isLike
        
        super.init(nibName: nil, bundle: nil)
        
        setNavigation(productName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigation(_ title: String) {
        navigationItem.title = title
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
        
        let barButtonItem = UIBarButtonItem(image: isLike ? UIImage.likeSelected : UIImage.likeUnselected.withRenderingMode(.alwaysOriginal),
                                            style: .plain, target: self, action: #selector(likeBtnDidTap))
        
        barButtonItem.tintColor = .meaningBlack
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setLayout() {
        view.addSubview(webView)
        view.addSubview(indicatorView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func likeBtnDidTap() {
        isLike.toggle()
        completionHandler?(isLike)
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.stopAnimating()
    }
}

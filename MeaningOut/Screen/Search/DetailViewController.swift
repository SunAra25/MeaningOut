//
//  DetailViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import UIKit
import SnapKit
import WebKit

final class DetailViewController: BaseViewController {
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
    private let navigationTitle: String
    
    var completionHandler: ((Bool) -> ())?
    
    init(productName: String, link: String, isLike: Bool) {
        urlLink = URL(string: link)
        self.isLike = isLike
        self.navigationTitle = productName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = title
        
        let barButtonItem = UIBarButtonItem(image: isLike ? UIImage.likeSelected : UIImage.likeUnselected.withRenderingMode(.alwaysOriginal),
                                            style: .plain, target: self, action: #selector(likeBtnDidTap))
        
        barButtonItem.tintColor = .meaningBlack
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func setHierachy() {
        view.addSubview(webView)
        view.addSubview(indicatorView)
    }
    
    override func setConstraints() {
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

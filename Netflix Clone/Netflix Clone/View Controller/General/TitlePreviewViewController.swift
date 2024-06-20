//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 08/03/24.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let webView : WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private let overViewLable : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Best Movie"
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLable)
        view.addSubview(downloadButton)
        configureConstraints()
        // Do any additional setup after loading the view.
    }
    
    func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
            
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let overviewLabelConstraints = [
            overViewLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 15),
            overViewLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(overviewLabelConstraints)
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overViewLable.bottomAnchor,constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model:TitlePreviewViewModel) {
        titleLabel.text = model.title
        overViewLable.text = model.overviewTitle
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}

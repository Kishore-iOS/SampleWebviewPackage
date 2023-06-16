//
//  WebViewController.swift
//  
//
//  Created by Fuzionest on 16/06/23.
//

import UIKit
import WebKit

public protocol WebViewControllerDelegate {
    func didTapBack()
    func didTapSuccess()
    func didTapFail()
    func didLoadFail(message: String)
}

public class WebViewController: UIViewController {
    @objc var webView : WKWebView = WKWebView()
    var actInd: UIActivityIndicatorView?
    public var delegate : WebViewControllerDelegate?
    public var customBackButton : UIButton?
    public var urlTxt = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        self.addBackButton()
        self.addWebview()
    }
    
    func addBackButton() {
        if let customBackButton = self.customBackButton {
            customBackButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
        }
        else {
            let backButton = UIButton(type: .custom)
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(backButton.tintColor, for: .normal)
            backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.delegate?.didTapBack()
        self.dismiss(animated: true, completion: nil)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func addWebview() {
        DispatchQueue.main.async {
            self.navigationController?.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            self.createWebView()
        }
        self.loadWebView()
    }
    
    @objc func createWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let viewBack = UIView()
        self.view.backgroundColor = .white
        viewBack.backgroundColor = .white
        viewBack.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height-60)
        
        self.webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        self.webView.frame = CGRect(x: 0, y: 0, width: viewBack.bounds.width, height: viewBack.bounds.height)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = .white
        self.webView.scrollView.delegate = self
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.scrollView.alwaysBounceHorizontal = false
        self.webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        self.webView.scrollView.alwaysBounceVertical = false
        self.webView.scrollView.isDirectionalLockEnabled = true
        self.webView.backgroundColor = UIColor.white
        self.webView.isMultipleTouchEnabled = false
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.scrollView.minimumZoomScale = 1.0;
        self.webView.scrollView.maximumZoomScale = 1.0;
        viewBack.addSubview(self.webView)
        self.view.addSubview(viewBack)
        self.showActivityIndicatory(uiView: self.webView)
    }
    
    @objc func loadWebView() {
        if let newurl = URL(string: self.urlTxt) {
            let newrequest = URLRequest(url: newurl)
            DispatchQueue.main.async {
                self.webView.load(newrequest)
            }
        }
        else {
            DispatchQueue.main.async {
                self.delegate?.didLoadFail(message: "Something went wrong!")
                self.dismiss(animated: true, completion: nil)
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        self.actInd = UIActivityIndicatorView()
        self.actInd?.frame = CGRect(x: 0.0, y: -20, width: 40.0, height: 40.0);
        self.actInd?.center = uiView.center
        self.actInd?.hidesWhenStopped = true
        self.actInd?.style = UIActivityIndicatorView.Style.medium
        self.actInd?.color = .black
        uiView.addSubview(self.actInd!)
        self.actInd?.startAnimating()
    }
}

extension WebViewController : WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.actInd?.startAnimating()
        self.actInd?.isHidden = false
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.actInd?.startAnimating()
        self.actInd?.isHidden = false
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.actInd?.stopAnimating()
        self.actInd?.isHidden = true
        
        DispatchQueue.main.async {
            self.delegate?.didLoadFail(message: "Network error!")
            self.dismiss(animated: true, completion: nil)
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webViewDidStartLoad(_ : WKWebView) {
        self.actInd?.startAnimating()
        self.actInd?.isHidden = false
    }
    
    func webViewDidFinishLoad(_ : WKWebView){
        self.actInd?.stopAnimating()
        self.actInd?.isHidden = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.actInd?.stopAnimating()
        self.actInd?.isHidden = true
        if (webView.url?.path.contains("webview_close.html"))!{
            
        }
    }
}


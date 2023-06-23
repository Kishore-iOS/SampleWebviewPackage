//
//  WebBookingViewController.swift
//  
//
//  Created by Fuzionest on 16/06/23.
//

import UIKit
import WebKit

public protocol WebBookingDelegate {
    func bookingSuccess(tripId: String, message: String)
    func bookingFail(message: String)
    func webViewError(message: String)
}

public class WebBookingViewController: UIViewController {
    @objc var webView : WKWebView = WKWebView()
    public var delegate : WebBookingDelegate?
    private let urlTxt = "https://booking.royalsmartlimousine.com/?type=3"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.addWebview()
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Web Booking"
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(self.backAction(_:)))
        backBtn.tintColor = .black
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc func backAction(_ sender: UIButton) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addWebview() {
        DispatchQueue.main.async {
            self.createWebView()
        }
        
        DispatchQueue.global(qos: .background).async {
            self.loadWebView()
        }
    }
    
    @objc func createWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let viewBack = UIView()
        self.view.backgroundColor = .white
        viewBack.backgroundColor = .white
        viewBack.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        self.webView.frame = CGRect(x: 0, y: 0, width: viewBack.bounds.width, height: viewBack.bounds.height)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
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
                self.navigationController?.popViewController(animated: true)
                self.delegate?.webViewError(message: "Something went wrong!")
            }
        }
    }
}

extension WebBookingViewController : WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        print("webview url 1: \(url.absoluteString)")
        var tripId: String? = nil
        var msg: String? = nil
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "tripId" {
                    if let trip_id = queryItem.value {
                        print("tripId: \(trip_id)")
                        tripId = trip_id
                    }
                }
                else if queryItem.name == "msg" {
                    if let message = queryItem.value {
                        print("msg: \(message)")
                        msg = message
                    }
                }
            }
        }

        if (url.absoluteString.contains("wrong")) {
            decisionHandler(.cancel)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.bookingFail(message: msg ?? "Booking failed")
        }
        else if (url.absoluteString.contains("success")) {
            decisionHandler(.cancel)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.bookingSuccess(tripId: tripId ?? "", message: msg ?? "Booking success")
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.webViewError(message: "Network error!")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

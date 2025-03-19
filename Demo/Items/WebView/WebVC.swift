//
//  WebVC.swift
//  Demo
//
//  Created by WangBo on 2023/2/28.
//  Copyright © 2023 wangbo. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class WebVC: UIViewController, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message from JavaScript: \(message)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui()
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
//        print(request.url?.absoluteString)
//        return true
//    }

}

extension WebVC {
    private func ui() {
//        webview1()
        webViwe2()
    }
    
    private func webview1() {
        let userContent = WKUserContentController.init()
        userContent.add(self, name: "onGoBack")
        let config = WKWebViewConfiguration.init()
        config.userContentController = userContent

        let wkWebView: WKWebView = WKWebView.init(frame: view.bounds, configuration: config)
        view.addSubview(wkWebView)

        let url = URL(string: "http://skin-view-test.myreal3d.com/customer?scope=OPEN:basic&channel_id=25853&store_id=001&token=eyJpdiI6InhCUUFUSnMxQXd4NGFuTGJDb0dVYWc9PSIsInZhbHVlIjoiNmlldGZxbVF1NVNwSG95dTA0YUN0UFhPdnhOYWRySlZUWVhmbVpXV2FtSFNwN3VNaGtycXUxbjkrNWE3elh1UEFObE9UTmJUUENOa3labERZc2tBQkE9PSIsIm1hYyI6ImVhZTJlMGQ0MDRlMjlhYWIzNGNjMDk3N2RhMWM2NTMwNDk4MjRiNWFjYzJlYTlhNTQ2ZWJhNmJjNDE2ODZiZmQiLCJ0YWciOiIifQ==")
        wkWebView.load(URLRequest.init(url: url!))
    }
    
    private func webViwe2() {
//        let userContent = WKUserContentController.init()
//        userContent.add(self, name: "onGoBack")
//        let config = WKWebViewConfiguration.init()
//        config.userContentController = userContent
//
//        let webview = UIWebView(frame: self.view.bounds)
//        view.addSubview(webview)
////        webview.delegate = self
//
//        let url = URL(string: "http://skin-view-test.myreal3d.com/customer?scope=OPEN:basic&channel_id=25853&store_id=001&token=eyJpdiI6InhCUUFUSnMxQXd4NGFuTGJDb0dVYWc9PSIsInZhbHVlIjoiNmlldGZxbVF1NVNwSG95dTA0YUN0UFhPdnhOYWRySlZUWVhmbVpXV2FtSFNwN3VNaGtycXUxbjkrNWE3elh1UEFObE9UTmJUUENOa3labERZc2tBQkE9PSIsIm1hYyI6ImVhZTJlMGQ0MDRlMjlhYWIzNGNjMDk3N2RhMWM2NTMwNDk4MjRiNWFjYzJlYTlhNTQ2ZWJhNmJjNDE2ODZiZmQiLCJ0YWciOiIifQ==")
//        webview.loadRequest(URLRequest.init(url: url!))
    }
}


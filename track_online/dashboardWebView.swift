//
//  dashboardWebView.swift
//  track_online
//
//  Created by 刈田修平 on 2019/09/01.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit
import WebKit
class dashboardViewController: WKWebView {
    @IBOutlet weak var dashboardWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://track-online.herokuapp.com/")
        let request = URLRequest(url:  url!)
        dashboardWebView.load(request)
        //        self.diaryWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

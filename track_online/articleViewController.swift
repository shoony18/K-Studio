//
//  articleViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/03/22.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import WebKit

class articleViewController: UIViewController {

    @IBOutlet weak var articleView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://track-online.herokuapp.com/article/index")
        let request = URLRequest(url:  url!)
        articleView.load(request)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

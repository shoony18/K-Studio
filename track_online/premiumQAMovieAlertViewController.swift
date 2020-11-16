//
//  premiumQAMovieAlertViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/11/16.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseMessaging
import Photos
import MobileCoreServices
import AssetsLibrary


class premiumQAMovieAlertViewController: UIViewController {
    @IBOutlet var approveFlagButton: UIButton!
    @IBOutlet var goToButton: UIButton!
    
    var approveFlag:Int = 0
    let Ref = Database.database().reference()

    override func viewDidLoad() {
        loadRuleText()
        goToButton.isEnabled = false
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func loadRuleText(){
        let ref1 = Ref.child("purchase").child("premium").child("setting").child("userRule")

    }
    @IBAction func tapApproveFlagButton(_ sender: Any) {
        if approveFlag == 0{
            approveFlag = 1
            let picture = UIImage(named: "checkFlag_fill")
            self.approveFlagButton.setImage(picture, for: .normal)
            goToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            goToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            goToButton.isEnabled = true
        }else if approveFlag == 1{
            approveFlag = 0
            let picture = UIImage(named: "checkFlag")
            self.approveFlagButton.setImage(picture, for: .normal)
            goToButton.tintColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            goToButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            goToButton.isEnabled = false
        }
    }
    
    @IBAction func goToPremiumQAForm(_ sender: Any) {
        performSegue(withIdentifier: "goToPremiumQAForm", sender: nil)
    }

}

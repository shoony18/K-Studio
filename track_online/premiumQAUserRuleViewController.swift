//
//  premiumQAUserRuleViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/24.
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


class premiumQAUserRuleViewController: UIViewController {

    @IBOutlet var ruleText: UILabel!
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
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["ruleText"] as? String ?? ""
            self.ruleText.text = key
        })

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
    
    @IBAction func goToMovieAlert(_ sender: Any) {
        performSegue(withIdentifier: "goToMovieAlert", sender: nil)
    }
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

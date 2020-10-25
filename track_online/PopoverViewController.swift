//
//  PopoverViewController.swift
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


class PopoverViewController: UIViewController {

    var check1:Int?
    var check2:Int?
    var check3:Int?
    @IBOutlet var backToButton: UIButton!
    @IBOutlet var check1Button: UIButton!
    @IBOutlet var check2Button: UIButton!
    @IBOutlet var check3Button: UIButton!

    override func viewDidLoad() {
        backToButton.isEnabled = false
        check1 = 0
        check2 = 0
        check3 = 0
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadRuleText(){
//        let ref1 = Ref.child("purchase").child("premium").child("setting").child("userRule")
//        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
//          let value = snapshot.value as? NSDictionary
//            let key = value?["ruleText"] as? String ?? ""
//            self.ruleText.text = key
//        })

    }
    @IBAction func tapCheck1Button(_ sender: Any) {
        if check1 == 0{
            check1 = 1
            let picture = UIImage(named: "checkFlag_fill")
            self.check1Button.setImage(picture, for: .normal)
            if check2 == 1 || check3 == 1{
                backToButton.isEnabled = true
                backToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                backToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            }
        }else if check1 == 1{
            check1 = 0
            let picture = UIImage(named: "checkFlag")
            self.check1Button.setImage(picture, for: .normal)
            backToButton.tintColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            backToButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            backToButton.isEnabled = false
        }
    }
    @IBAction func tapCheck2Button(_ sender: Any) {
        if check2 == 0{
            check2 = 1
            check3 = 0
            let picture1 = UIImage(named: "checkFlag_fill")
            let picture2 = UIImage(named: "checkFlag")
            self.check2Button.setImage(picture1, for: .normal)
            self.check3Button.setImage(picture2, for: .normal)
            if check1 == 1{
                backToButton.isEnabled = true
                backToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                backToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            }
        }else if check2 == 1{
            check2 = 0
            check3 = 1
            let picture1 = UIImage(named: "checkFlag")
            let picture2 = UIImage(named: "checkFlag_fill")
            self.check2Button.setImage(picture1, for: .normal)
            self.check3Button.setImage(picture2, for: .normal)
            if check1 == 1{
                backToButton.isEnabled = true
                backToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                backToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            }
        }
    }
    @IBAction func tapCheck3Button(_ sender: Any) {
        if check3 == 0{
            check2 = 0
            check3 = 1
            let picture1 = UIImage(named: "checkFlag")
            let picture2 = UIImage(named: "checkFlag_fill")
            self.check2Button.setImage(picture1, for: .normal)
            self.check3Button.setImage(picture2, for: .normal)
            if check1 == 1{
                backToButton.isEnabled = true
                backToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                backToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            }
        }else if check3 == 1{
            check2 = 1
            check3 = 0
            let picture1 = UIImage(named: "checkFlag_fill")
            let picture2 = UIImage(named: "checkFlag")
            self.check2Button.setImage(picture1, for: .normal)
            self.check3Button.setImage(picture2, for: .normal)
            if check1 == 1{
                backToButton.isEnabled = true
                backToButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                backToButton.backgroundColor = UIColor(red: 83/255, green: 166/255, blue: 165/255, alpha: 1)
            }
        }
    }

}

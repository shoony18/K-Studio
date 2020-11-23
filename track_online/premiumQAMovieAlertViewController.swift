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
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var playVideo: UIButton!

    let imagePickerController = UIImagePickerController()
    var cache: String?
    var videoURL: URL?
    var playUrl:NSURL?
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()

    var approveFlag:Int = 0
    let Ref = Database.database().reference()

    override func viewDidLoad() {
        goToButton.isEnabled = false
        playVideo.isEnabled = false
        loadRuleText()
        loadMovie()
        download()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func loadRuleText(){
        let ref1 = Ref.child("purchase").child("premium").child("setting").child("userRule")

    }
    func loadMovie(){
        let textImage:String = "movieAlert.png"
        let refImage = Storage.storage().reference().child("purchase").child("premium").child("setting").child("movieAlert").child("\(textImage)")
        ImageView.sd_setImage(with: refImage, placeholderImage: nil)
        playVideo.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)

    }
    @objc func playVideo(_ sender: UIButton) {
        let player = AVPlayer(url: playUrl! as URL
        )
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            controller.player!.play()
        }
    }
    
    func download(){
        let textVideo:String = "movieAlert.mp4"
        let refVideo = Storage.storage().reference().child("purchase").child("premium").child("setting").child("movieAlert").child("\(textVideo)")
        refVideo.downloadURL{ [self] url, error in
            if (error != nil) {
            } else {
                self.playUrl = url as NSURL?
                print("download success!! URL:", url!)
            }
            playVideo.isEnabled = true
        }
        //        if self.cache == "1"{
        //            SDImageCache.shared.clearMemory()
        //            SDImageCache.shared.clearDisk()
        //            let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("private").child("\(text!)")
        //            let data = ["cache":"0" as Any] as [String : Any]
        //            ref0.updateChildValues(data)
        //        }
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

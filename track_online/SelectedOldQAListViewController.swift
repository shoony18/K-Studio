//
//  SelectedOldQAListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/21.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary

class SelectedOldQAListViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var TextFieldGenre: UILabel!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var userQAText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var trackAnswer: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var editQA: UIButton!
    var roomArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid
    var goodButtonValue:String?
    var badButtonValue:String?


    override func viewDidLoad() {
        self.PlayButton.isHidden = true
        selectedText.text = text
        userQA()
        download()
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        userQA()
        super.viewWillAppear(animated)
    }
        
    func userQA(){
        let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("\(text!)")
            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
                let value = snapshot.value as? NSDictionary
                let key = value?["TextFieldGenre"] as? String ?? ""
                if key.isEmpty{
                    self.TextFieldGenre.text = "-"
                }else{
                    self.TextFieldGenre.text = key
                }

              // ...
              }) { (error) in
                print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let key = value?["TextViewQAcontent"] as? String ?? ""
              self.userQAText.text = key

              // ...
              }) { (error) in
                print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let key = value?["trackAnswer"] as? String ?? ""
              self.trackAnswer.text = key
              // ...
              }) { (error) in
                print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
            let value = snapshot.value as? NSDictionary
            let key = value?["sankouURL"] as? String ?? ""
    //          self.trackAnswer.text = key
    //            let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
            let attributedString = NSMutableAttributedString(string: key)
            attributedString.addAttribute(.link,
                                              value: key,
                                              range: NSString(string: key).range(of: key))
            self.sankouURL.attributedText = attributedString
                // isSelectableをtrue、isEditableをfalseにする必要がある
                // （isSelectableはデフォルトtrueだが説明のため記述）
            self.sankouURL.isSelectable = true
            self.sankouURL.isEditable = false
            self.sankouURL.delegate = self as UITextViewDelegate
                print("sankouURL")

              // ...
        }) { (error) in
                print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["goodButton"] as? String ?? ""
            self.goodButtonValue = key
                print("\(self.goodButtonValue!)")
            if self.goodButtonValue == "1"{
                print("\(key)")
                let picture1 = UIImage(named: "hand.thumbsup.fill")
                self.goodButton.setImage(picture1, for: .normal)
                let picture0 = UIImage(named: "hand.thumbsdown")
                self.badButton.setImage(picture0, for: .normal)
                }
            }) { (error) in
                print(error.localizedDescription)
        }
        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["badButton"] as? String ?? ""
            self.badButtonValue = key
                print("\(self.badButtonValue!)")
            if self.badButtonValue == "1"{
                print("badButton == 1")
                let picture1 = UIImage(named: "hand.thumbsdown.fill")
                self.goodButton.setImage(picture1, for: .normal)
                let picture0 = UIImage(named: "hand.thumbsup")
                self.badButton.setImage(picture0, for: .normal)
                }
            }) { (error) in
                print(error.localizedDescription)
        }
            
            print(userQAText.text!)
            print(trackAnswer.text!)
        }
        func download(){
            let textVideo:String = text!+".mp4"
            let textImage:String = text!+".png"
            let refVideo = Storage.storage().reference().child("QA").child("\(currentUid)").child(text!).child("\(textVideo)")
            print("\(refVideo)")
            refVideo.downloadURL{ url, error in
            if (error != nil) {
                print("QA添付動画なし")
                let imageView: UIImageView = self.UIimageView
                // Placeholder image
                let placeholderImage = UIImage(named: "rikujou_track_top.png")
                imageView.image = placeholderImage
            } else {
                self.playUrl = url as NSURL?
                print("download success!! URL:", url!)
                print("QA添付動画あり")
                self.PlayButton.isHidden = false
            }
            }
            let refImage = Storage.storage().reference().child("QA").child("\(currentUid)").child(text!).child("\(textImage)")

            // Load the image using SDWebImage
            if UIimageView != nil {
                let imageView: UIImageView = self.UIimageView
            // Placeholder image
                let placeholderImage = UIImage(named: "placeholder.png")
                imageView.sd_setImage(with: refImage, placeholderImage: placeholderImage)
            }
        }
        @IBAction func PlayButton(_ sender: Any) {
            let player = AVPlayer(url: playUrl! as URL
            )

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                controller.player!.play()
            }
        }
        @IBAction func removeQA(_ sender: Any) {
            let alert: UIAlertController = UIAlertController(title: "削除", message: "この質問を削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)

            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                Database.database().reference().child("QA").child("\(self.currentUid)").child("\(self.text!)").removeValue()
                self.navigationController?.popViewController(animated: true)
                print("OK")
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }

}

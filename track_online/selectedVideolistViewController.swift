//
//  selectedVideolistViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/17.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary

class selectedVideolistViewController: UIViewController {
    @IBOutlet weak var selectedText: UILabel!
    var roomArray = [String]()
//    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid

    @IBOutlet weak var attachedVideoButton: UIButton!
    @IBOutlet weak var adviseText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    override func viewDidLoad() {
        selectedText.text = text
        trackAdvise()
        download()
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
//        selectedText.sizeToFit()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func trackAdvise(){
        let ref = Database.database().reference().child("\(currentUid)").child("\(text!)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["adviseText"] as? String ?? ""
          self.adviseText.text = key

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        print(adviseText.text!)
    }
    func download(){
        let textVideo:String = text!+".mp4"
        let textImage:String = text!+".png"
        let refVideo = Storage.storage().reference().child("\(currentUid)").child(text!).child("\(textVideo)")
        refVideo.downloadURL{ url, error in
        if (error != nil) {
            print("Uh-oh, an error occurred!")
        } else {
            self.playUrl = url as NSURL?
            print("download success!! URL:", url!)
        }
        }
        let refImage = Storage.storage().reference().child("\(currentUid)").child(text!).child("\(textImage)")
        let imageView: UIImageView = self.UIimageView

        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.png")

        // Load the image using SDWebImage
        imageView.sd_setImage(with: refImage, placeholderImage: placeholderImage)
        
        let attacedText:String = "track_"+text!+".mp4"
        let refAttacedVideo = Storage.storage().reference().child("\(currentUid)").child(text!).child("\(attacedText)")
        refAttacedVideo.downloadURL{ url, error in
        if (error != nil) {
            print("Uh-oh, an error occurred!")
        } else {
            self.attachedUrl = (url! as NSURL)
            self.attachedVideoButton.setTitle(attacedText, for: .normal)
            print("download success!! URL:", url!)
        }
        }

    }
//    func previewImageFromVideo(_ url:URL) -> UIImage? {
//
//        print("動画からサムネイルを生成する")
//        let asset = AVAsset(url:url)
//        let imageGenerator = AVAssetImageGenerator(asset:asset)
//        imageGenerator.appliesPreferredTrackTransform = true
//        var time = asset.duration
//        time.value = min(time.value,2)
//        do {
//            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
//            return UIImage(cgImage: imageRef)
//        } catch {
//            return nil
//        }
//
//    }


    @IBAction func playButton(_ sender: Any) {
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
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
    @IBAction func attachedVideo(_ sender: Any) {
        let player = AVPlayer(url: attachedUrl! as URL)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            controller.player!.play()
        }
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

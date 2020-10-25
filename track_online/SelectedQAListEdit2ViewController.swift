//
//  SelectedQAListEdit2ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/20.
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

class SelectedQAListEdit2ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var QASpeciality: UILabel!
    @IBOutlet weak var QAContent: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playVideo: UIButton!
    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var currentAsset: AVAsset?
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let currentUserEmail:String = Auth.auth().currentUser!.email!
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()
    
    let bundleDataType: String = "mp4"
    var text: String?
    var flag: String?
    var cache: String? = "0"
    var selectedspeciality: String?
    var selectedQAContent: String?
    var selectedAnswer: String?
    var selectedUid: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    var selectedSpeciality:[String] = []
    var txtActiveView = UITextView()
    // 現在選択されているTextField
    var selectedTextView:UITextView?

    override func viewDidLoad() {
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        QAContent.inputAccessoryView = toolbar
        userQA()
        download()
        self.contentView.addSubview(imageView)
        self.contentView.sendSubviewToBack(imageView);

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

       super.viewWillAppear(animated)
    }
    @objc func done() {
        self.view.endEditing(true)
    }
    func userQA(){
        QASpeciality.text = selectedspeciality
        QAContent.text = selectedQAContent
    }
    func download(){
        
        let textVideo:String = text!+".mp4"
        let textImage:String = text!+".png"
        let refVideo = Storage.storage().reference().child("QA").child("\(currentUid)").child("private").child(text!).child("\(textVideo)")
        print("\(refVideo)")
        refVideo.downloadURL{ url, error in
        if (error != nil) {
            print("QA添付動画なし")
            let imageView: UIImageView = self.imageView
            // Placeholder image
            let placeholderImage = UIImage(named: "rikujou_track_top.png")
            imageView.image = placeholderImage
        } else {
            self.playUrl = url as NSURL?
            print("download success!! URL:", url!)
            print("QA添付動画あり")
        }
        }
//        let now = NSDate()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
//        let timenow = formatter.string(from: now as Date)

        let refImage = Storage.storage().reference().child("QA").child("\(currentUid)").child("private").child(text!).child("\(textImage)")

        if imageView != nil {
            let imageView: UIImageView = self.imageView
            //
//            let placeholderImage = UIImage(named: "\(timenow)placeholder.png")
            imageView.sd_setImage(with: refImage, placeholderImage: nil)
        }
    }
    @IBAction func PlayButton(_ sender: Any) {
        
        if let videoURL = videoURL{
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                print("動画再生")
                playerViewController.player!.play()
            }
        }else{
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

    }
      
    @IBAction func selectedImage(_ sender: Any) {
          imagePickerController.sourceType = .photoLibrary
//          //imagePickerController.mediaTypes = ["public.image", "public.movie"]
          imagePickerController.delegate = self
          //動画だけ
          imagePickerController.mediaTypes = ["public.movie"]
          //画像だけ
          //imagePickerController.mediaTypes = ["public.image"]
          present(imagePickerController, animated: true, completion: nil)
          print("選択できた！")
      
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        print("yes！")

        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        imageView.image = previewImageFromVideo(videoURL!)!
        imageView.contentMode = .scaleAspectFit
        self.cache = "1"
        print("\(self.cache!)")
        imagePickerController.dismiss(animated: true, completion: nil)

    }
    func previewImageFromVideo(_ url:URL) -> UIImage? {
        print("動画からサムネイルを生成する")
        let asset = AVAsset(url:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = min(time.value,0)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            // PNG形式の画像フォーマットとしてNSDataに変換
            data = image.pngData()
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    @IBAction func resendQA(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で送信していいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let ref0 = Database.database().reference().child("QA").child("\(self.currentUid)").child("private").child("\(self.text!)")
            let ref1 = Database.database().reference().child("QA").child("private").child("\(self.QASpeciality.text!)").child("\(self.text!)")
            let ref2 = Database.database().reference().child("QA").child("private").child("全て").child("\(self.text!)")
            let data = ["QAContent":"\(self.QAContent.text!)","cache":"\(self.cache!)" as Any] as [String : Any]
            ref0.updateChildValues(data)
            ref1.updateChildValues(data)
            ref2.updateChildValues(data)

            let textVideo:String = self.text!+".mp4"
            let textImage:String = self.text!+".png"

            if self.cache == "1"{
                let refVideo = Storage.storage().reference().child("QA").child("\(self.currentUid)").child("private").child(self.text!).child("\(textVideo)")
                refVideo.delete { error in
                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == StorageErrorDomain &&
                        nsError.code == StorageErrorCode.objectNotFound.rawValue {
                        print("目的の参照にオブジェクトが存在しません")
                    }
                } else {
                    print("delete success!!")
                }
                }

                let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                /// create a temporary file for us to copy the video to.
                let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(self.videoURL!.lastPathComponent )
                /// Attempt the copy.
                do {
                    try FileManager().copyItem(at: self.videoURL!.absoluteURL, to: temporaryFileURL)
                } catch {
                    print("There was an error copying the video file to the temporary location.")
                }
                print("\(temporaryFileURL)")
                refVideo.putFile(from: temporaryFileURL, metadata: nil) { metadata, error in
                    guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                        print("error")
                        return
                    }
                  // Metadata contains file metadata such as size, content-type.
                    _ = metadata.size
                  // You can also access to download URL after upload.
                    refVideo.downloadURL { (url, error) in
                        guard url != nil else {
                      // Uh-oh, an error occurred!
                            return
                        }
                    }
            }
            let refImage = Storage.storage().reference().child("QA").child("\(self.currentUid)").child("private").child(self.text!).child("\(textImage)")
            refImage.delete { error in
                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == StorageErrorDomain &&
                        nsError.code == StorageErrorCode.objectNotFound.rawValue {
                        print("目的の参照にオブジェクトが存在しません")
                    }
                } else {
                    print("delete success!!")
                }
            }
            refImage.putData(self.data!, metadata: nil) { metadata, error in
                    guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                        print("error")
                        return
                    }
                  // Metadata contains file metadata such as size, content-type.
                    _ = metadata.size
                  // You can also access to download URL after upload.
                    refImage.downloadURL { (url, error) in
                        guard url != nil else {
                      // Uh-oh, an error occurred!
                            return
                        }
                    }
                }
                
            }
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{(action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
        

}

//
//  homeViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/04.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import Photos
import MobileCoreServices
import AssetsLibrary


class homeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIScrollViewDelegate  {
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var currentAsset: AVAsset?
    let currentUid:String = Auth.auth().currentUser!.uid
    var data:Data?
        
    @IBOutlet weak var imageView: UIImageView!
    var currentTextField = UITextField()
    var currentTextView = UITextView()
    var pickerview = UIPickerView()
    
    var selectedAge:[String] = []
    var selectedSex:[String] = []
    var selectedGenre:[String] = []
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var textValidateAge: UILabel!
    @IBOutlet weak var textValidateSex: UILabel!
    @IBOutlet weak var textValidateGenre: UILabel!
    @IBOutlet weak var textValidateVideo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        selectedAge = ["","7","8","9","10","11","12","13","14","15","16","17","18"]
        selectedSex = ["","男","女","非公開"]
        selectedGenre = ["","短距離","中距離","長距離","跳躍","投擲","混成","その他"]
        print("\(selectedAge)")
        textValidateAge.isHidden = true
        textValidateSex.isHidden = true
        textValidateGenre.isHidden = true
        textValidateVideo.isHidden = true

        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        let toolbar0 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done0))
        toolbar0.setItems([spacelItem0, doneItem0], animated: true)

        // インプットビュー設定
        textField1.inputView = pickerview
        textField2.inputView = pickerview
        textField3.inputView = pickerview
        textField1.inputAccessoryView = toolbar
        textField2.inputAccessoryView = toolbar
        textField3.inputAccessoryView = toolbar
        textView1.inputAccessoryView = toolbar0
        // Do any additional setup after loading the view.
//        imageView.image = UIImage(named: "斜線")
//        // 画像のフレームを設定
//        imageSample.frame = CGRect(x:0, y:0, width:128, height:128)
//
//        // 画像を中央に設定
//        imageSample.center = CGPoint(x:screenW/2, y:screenH/2)
         
        // 設定した画像をスクリーンに表示する
//        scrollView.delegate = self as UIScrollViewDelegate
//        scrollView.addSubview(imageView)

        self.contentView.addSubview(imageView)
        self.contentView.sendSubviewToBack(imageView);
        super.viewDidLoad()

    }
    
    @objc func done() {
        if currentTextField == textField1 {
            textField1.endEditing(true)
            textField1.text = "\(selectedAge[pickerview.selectedRow(inComponent: 0)])"
        } else if currentTextField == textField2 {
            textField2.endEditing(true)
            textField2.text = "\(selectedSex[pickerview.selectedRow(inComponent: 0)])"
        } else if currentTextField == textField3 {
            textField3.endEditing(true)
            textField3.text = "\(selectedGenre[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    @objc func done0() {
        self.view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == textField1 {
            return selectedAge.count
        } else if currentTextField == textField2 {
            return selectedSex.count
        } else if currentTextField == textField3 {
            return selectedGenre.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == textField1 {
            return selectedAge[row]
        } else if currentTextField == textField2 {
            return selectedSex[row]
        } else if currentTextField == textField3 {
            return selectedGenre[row]
        } else {
            print("nil")
            return ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == textField1{
            currentTextField.inputView = pickerview
        }else if currentTextField == textField2{
            currentTextField.inputView = pickerview
        }else if currentTextField == textField3{
            currentTextField.inputView = pickerview
        }else{
            print("nil")
        }
    }

    @IBAction func selectedImage(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        //imagePickerController.mediaTypes = ["public.image", "public.movie"]
        imagePickerController.delegate = self
        //動画だけ
        imagePickerController.mediaTypes = ["public.movie"]
        //画像だけ
        //imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
        print("選択できた！")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("yes！")

        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        imageView.image = previewImageFromVideo(videoURL!)!
        imageView.contentMode = .scaleAspectFit
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
    @IBAction func playMovie(_ sender: Any) {
        if let videoURL = videoURL{
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                print("動画再生")
                playerViewController.player!.play()
            }
        }
    }
    override func shouldPerformSegue(
        withIdentifier identifier: String,
        sender: Any?) -> Bool {

        if identifier == "sentVideo" {
            if textField1.text == "" || textField2.text == "" || textField3.text == "" || videoURL == nil {
                return false
            }
        }
        return true
    }

    @IBAction func sendVideo(_ sender: UIButton) {

        textValidateAge.isHidden = true
        textValidateSex.isHidden = true
        textValidateGenre.isHidden = true
        if textField1.text?.count == 0 {
            textValidateAge.isHidden = false
            textValidateAge.text = "年齢を選択してください"
            return
        }
        if textField2.text?.count == 0 {
            textValidateSex.isHidden = false
            textValidateSex.text = "性別を選択してください"
            return
        }
        if textField3.text?.count == 0 {
            textValidateGenre.isHidden = false
            textValidateGenre.text = "専門を選択してください"
            return
        }
        if videoURL == nil {
            textValidateVideo.isHidden = false
            textValidateVideo.text = "動画を選択してください"
            return
        }
        
        
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timenow = formatter.string(from: now as Date)
        let storageReference = Storage.storage().reference().child("\(currentUid)").child("\(timenow)").child("\(timenow).mp4")
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        /// create a temporary file for us to copy the video to.
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(videoURL!.lastPathComponent )
        /// Attempt the copy.
        do {
            try FileManager().copyItem(at: videoURL!.absoluteURL, to: temporaryFileURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }
        print("\(temporaryFileURL)")

        storageReference.putFile(from: temporaryFileURL, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            print("error")
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          storageReference.downloadURL { (url, error) in
            guard url != nil else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        let storageReferenceImage = Storage.storage().reference().child("\(currentUid)").child("\(timenow)").child("\(timenow).png")
        storageReferenceImage.putData(data!, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            print("error")
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          storageReference.downloadURL { (url, error) in
            guard url != nil else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }

        let videoRef = Database.database().reference().child("\(currentUid)").childByAutoId()
        let videoObject = [
            "videoname":"\(timenow)"
        ]
        
        videoRef.setValue(videoObject, withCompletionBlock:{error,ref in
            if error == nil{
                print("Successful  upload")
//                self.dismiss(animated: true, completion: nil)
            }else{
            }
        })
        let commentRef = Database.database().reference().child("\(currentUid)").child("\(timenow)")
        let commentObject = [
            "adviseText":"まだコメントはありません"
        ]
        commentRef.setValue(commentObject, withCompletionBlock:{error,ref in if error == nil{
            print("コメントをアップロードしました")
        //                self.dismiss(animated: true, completion: nil)
        }else{
            }
        })
        let textViewRef = Database.database().reference().child("\(currentUid)").child("\(timenow)").child("textView")
        let textViewObject = [
            "textView1":"\(textView1.text!)"
        ]
        textViewRef.setValue(textViewObject, withCompletionBlock:{error,ref in if error == nil{
            print("テキストビューをアップロードしました")
        //                self.dismiss(animated: true, completion: nil)
        }else{
            }
        })

        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
                    "age":textField1.text as Any,
                    "sex":textField2.text  as Any,
                    "genre":textField3.text as Any,
                    "timestamp":timenow as Any
            ]as[String:Any]
            
        postRef.setValue(postObject, withCompletionBlock:{error,ref in
            if error == nil{
        //                self.dismiss(animated: true, completion: nil)
            }else{
            }
        })

        
//        let alert: UIAlertController = UIAlertController(title: "動画を送りました", message: "1週間以内にアドバイスが送られてきます", preferredStyle:  .alert)
//        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)

    }
    
}

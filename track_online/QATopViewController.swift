//
//  QATopViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/02/24.
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


class QATopViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIScrollViewDelegate{
    
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var currentAsset: AVAsset?
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let currentUserEmail:String = Auth.auth().currentUser!.email!
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()
    var currentTextField = UITextField()
    var currentTextView = UITextView()
    var selectedGenre:[String] = []
    var selectedRange:[String] = []
    var segueNumber: Int?
    var QAStatusArray = [String]()
    var CountQAStatusArray = Int()
    var QAStatusArray0 = [String]()
    var CountQAStatusArray0 = Int()
    var countPoint = Int()
    var pointExpense:String?
    let refreshControl = UIRefreshControl()
    let QARef = Database.database().reference().child("QA")
    var PublicOrPrivate:String?
    var firstLogin:String?
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowView0: UIView!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var shadowView4: UIView!
    @IBOutlet weak var shadowView5: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameHidden: UIButton!
    @IBOutlet weak var QASpeciality: UITextField!
    @IBOutlet weak var QAContent: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textValidateQASpeciality: UILabel!
    @IBOutlet weak var textValidateQAContent: UILabel!
    @IBOutlet weak var textValidateQAVideo: UILabel!
    @IBOutlet weak var textValidateQANumber: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var PlayButton: UIButton!
    
    override func viewDidLoad() {
        nameLabel.text = currentUserName
        QAContent.delegate = self
        selectedGenre = ["","短距離","中距離","長距離","跳躍","投擲","混成","その他"]
        textValidateQASpeciality.isHidden = true
        textValidateQAContent.isHidden = true
        textValidateQAVideo.isHidden = true
        textValidateQANumber.isHidden = true
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
        
        QASpeciality.inputView = pickerview
        QASpeciality.inputAccessoryView = toolbar
        QAContent.inputAccessoryView = toolbar0
        
        self.QARef.child(currentUid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let QAStatus = snap!["QAStatus"] as? String {
                        if QAStatus == "QAStatus0.png"{
                            self.QAStatusArray.append(QAStatus)
                            self.CountQAStatusArray = self.QAStatusArray.count
                        }else{
                        }
                    }
                }
            }
        }
        )
        refreshControl.addTarget(self, action: #selector(QATopViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
        contentView.addSubview(refreshControl)
        
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        refreshControl.endRefreshing()
        QASpeciality.text = ""
        QAContent.text = ""
        videoURL = nil
        imageView.image = UIImage(named: "斜線re.png")
        self.textValidateQASpeciality.isHidden = true
        self.textValidateQAContent.isHidden = true
        self.textValidateQAVideo.isHidden = true
        self.textValidateQANumber.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let beforeStr: String = QAContent.text // 文字列をあらかじめ取得しておく
        if QAContent.text.count > 50 { // 10000字を超えた時
            // 以下，範囲指定する
            let zero = beforeStr.startIndex
            let start = beforeStr.index(zero, offsetBy: 0)
            let end = beforeStr.index(zero, offsetBy: 50)
            QAContent.text = String(beforeStr[start...end])
            textValidateQAContent.isHidden = false
            textValidateQAContent.text = "質問内容は50文字以内にして下さい"
        }
    }
    @objc func done() {
        if currentTextField == QASpeciality{
            QASpeciality.endEditing(true)
            QASpeciality.text = "\(selectedGenre[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    @objc func done0() {
        self.view.endEditing(true)
    }
    
    @IBAction func nameHiddenButtonTapped(_ sender: Any) {
        if nameHidden.titleLabel?.text == "非表示"{
            let RandomString = randomString(length: 6) // 10桁のランダムな英数字を生成
            print(RandomString)
            nameLabel.text = RandomString
            nameHidden.setTitle("表示", for: .normal)
            return
        }
        if nameHidden.titleLabel?.text == "表示"{
            nameLabel.text = currentUserName
            nameHidden.setTitle("非表示", for: .normal)
            return
        }
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == QASpeciality {
            return selectedGenre.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == QASpeciality {
            return selectedGenre[row]
        }else {
            return ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == QASpeciality{
            currentTextField.inputView = pickerview
        }else{
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
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.PlayButton.isHidden = false
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
    @IBAction func sendVideo(_ sender: Any) {
        
        textValidateQASpeciality.isHidden = true
        textValidateQAContent.isHidden = true
        textValidateQAVideo.isHidden = true
        
        print(self.CountQAStatusArray)
        

        if QASpeciality.text?.count == 0 {
            textValidateQASpeciality.isHidden = false
            textValidateQASpeciality.text = "専門種目を選択してください"
            return
        }else if QAContent.text?.count == 0 {
            textValidateQAContent.isHidden = false
            textValidateQAContent.text = "質問文を入力してください"
            return
        }
        
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timenow = formatter.string(from: now as Date)
        
        let date1 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        let date = formatter1.string(from: date1)
        print("\(date)")
        let date2 = Date()
        let formatter2 = DateFormatter()
        formatter2.setLocalizedDateFormatFromTemplate("jm")
        let time = formatter2.string(from: date2)
        print("\(time)")
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この質問を送信します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let fcmData = ["fcmTrigger":"1"]
            let QAdata = ["QAName":"\(timenow)\(self.currentUid)","trackAnswer":"まだコメントはありません","QASpeciality":"\(self.QASpeciality.text!)","QAContent":"\(self.QAContent.text!)","QAStatus":"QAStatus0.png","goodButton":"0","badButton":"0","date":"\(date)","time":"\(time)","uuid":"\(self.currentUid)","userName":"\(self.nameLabel.text!)","registeredUserName":"\(self.currentUserName)","countAnswer":"0" as Any] as [String : Any]
            let answerdata = ["uuid":"\(self.currentUid)" as Any] as [String : Any]
            let QARef0 = self.QARef.child("\(self.currentUid)").child("public").child("\(timenow)\(self.currentUid)")
            let QARef1 = self.QARef.child("\(self.currentUid)").child("public").child("\(timenow)\(self.currentUid)").child("trackAnswer").child("\(self.currentUid)")
            let QARef2 = self.QARef.child("public").child("全て").child("\(timenow)\(self.currentUid)")
            let QARef3 = self.QARef.child("public").child("全て").child("\(timenow)\(self.currentUid)").child("trackAnswer").child("\(self.currentUid)")
            let QARef4 = self.QARef.child("public").child("\(self.QASpeciality.text!)").child("\(timenow)\(self.currentUid)")
            let QARef5 = self.QARef.child("public").child("\(self.QASpeciality.text!)").child("\(timenow)\(self.currentUid)").child("trackAnswer").child("\(self.currentUid)")
            QARef0.setValue(QAdata, withCompletionBlock:{error,ref in if error == nil{}})
            QARef0.child("fcmTrigger").setValue(fcmData)
            QARef1.setValue(answerdata, withCompletionBlock:{error,ref in if error == nil{}})
            QARef2.setValue(QAdata, withCompletionBlock:{error,ref in if error == nil{}})
            QARef3.setValue(answerdata, withCompletionBlock:{error,ref in if error == nil{}})
            QARef4.setValue(QAdata, withCompletionBlock:{error,ref in if error == nil{}})
            QARef5.setValue(answerdata, withCompletionBlock:{error,ref in if error == nil{}})
            
            let uuidData = ["uuid":"\(self.currentUid)","uuidQAStatus":"QAStatus0.png"]
            self.QARef.child("uuid").child("\(self.currentUid)").updateChildValues(uuidData)
            
            self.textValidateQASpeciality.isHidden = true
            self.textValidateQAContent.isHidden = true
            self.textValidateQAVideo.isHidden = true
            self.textValidateQANumber.isHidden = true
            self.QASpeciality.text = ""
            self.QAContent.text = ""
            self.dismiss(animated: true, completion: nil)
//
//            self.performSegue(withIdentifier: "ResultView", sender: true)
            
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
extension QATopViewController: UITextViewDelegate{
    //リターンキーでテキストフィールドを閉じる
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

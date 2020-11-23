//
//  premiumQAFormViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/17.
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
import StoreKit


class premiumQAFormViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UIScrollViewDelegate, UITextViewDelegate,UIPopoverPresentationControllerDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver {

    var myProduct:SKProduct?

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
    var selectedEvent:[String] = []
    var selectedPB1:[String] = []
    var selectedPB2:[String] = []
    var selectedHeight:[String] = []
    var selectedWeight:[String] = []
    var selectedRange:[String] = []
    var segueNumber: Int?
    var QAStatusArray = [String]()
    var CountQAStatusArray = Int()
    var QAStatusArray0 = [String]()
    var CountQAStatusArray0 = Int()
    var countPoint = Int()
    var pointExpense:String?
    let refreshControl = UIRefreshControl()
    let Ref = Database.database().reference()
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
    @IBOutlet weak var event: UITextField!
    @IBOutlet weak var PB1: UITextField!
    @IBOutlet weak var PB2: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var memo: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textValidate: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var PlayButton: UIButton!
    
    override func viewDidLoad() {
        loadData()
        fetchProducts()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func layout(){
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        shadowView0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowView4.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // 影の色
        shadowView0.layer.shadowColor = UIColor.black.cgColor
        shadowView1.layer.shadowColor = UIColor.black.cgColor
        shadowView2.layer.shadowColor = UIColor.black.cgColor
        shadowView3.layer.shadowColor = UIColor.black.cgColor
        shadowView4.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        shadowView0.layer.shadowOpacity = 0.3
        shadowView1.layer.shadowOpacity = 0.3
        shadowView2.layer.shadowOpacity = 0.3
        shadowView3.layer.shadowOpacity = 0.3
        shadowView4.layer.shadowOpacity = 0.3
        // 影をぼかし
        shadowView0.layer.shadowRadius = 4
        shadowView1.layer.shadowRadius = 4
        shadowView2.layer.shadowRadius = 4
        shadowView3.layer.shadowRadius = 4
        shadowView4.layer.shadowRadius = 4
    }
//    func fcmAuth(){
//        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {setting in
//             if setting.authorizationStatus == .authorized {
//                 let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"1" as AnyObject,"firstLogin":"1" as AnyObject]
//                 self.postToken(Token: token)
//                 print("許可")
//             }
//             else {
//                 let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"0" as AnyObject]
//                 self.postToken(Token: token)
//                 print("未許可")
//             }
//         })
//    }
//    func postToken(Token:[String: AnyObject]){
//        print("FCM Token:\(Token)")
//        let currentUid:String = Auth.auth().currentUser!.uid
//        let dbRef = Database.database().reference()
//        dbRef.child("fcmToken").child(currentUid).setValue(Token)
//    }

//    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
//        refreshControl.endRefreshing()
//        QASpeciality.text = ""
//        QAContent.text = ""
//        QAKoukaiRange.text = ""
//        videoURL = nil
//        imageView.image = UIImage(named: "斜線re.png")
//        self.textValidateQASpeciality.isHidden = true
//        self.textValidateQAContent.isHidden = true
//        self.textValidateQAVideo.isHidden = true
//        self.textValidateQANumber.isHidden = true
//        self.textValidateQAKoukaiRange.isHidden = true
//    }

//    @IBAction func inputPB(_ sender: Any) {
//        PB.text = (sender as AnyObject).text
//    }
//    @IBAction func inputHeight(_ sender: Any) {
//        height.text = (sender as AnyObject).text
//    }
//    @IBAction func inputWeight(_ sender: Any) {
//        weight.text = (sender as AnyObject).text
//    }
    func loadData(){
        selectedEvent = ["","短距離（100m）","短距離（200m）","短距離（400m）","跳躍（走幅跳）","跳躍（三段跳）"]
        for key in 0...99{
            selectedPB1.append(String(key))
            selectedPB2.append(String(key))
        }
        for key in 130...200{
            selectedHeight.append(String(key))
        }
        for key in 30...150{
            selectedWeight.append(String(key))
        }
        nameLabel.text = currentUserName
        memo.delegate = self
        textValidate.isHidden = true
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

        event.inputView = pickerview
        event.inputAccessoryView = toolbar
        PB1.inputView = pickerview
        PB1.inputAccessoryView = toolbar
        PB2.inputView = pickerview
        PB2.inputAccessoryView = toolbar
        height.inputView = pickerview
        height.inputAccessoryView = toolbar
        weight.inputView = pickerview
        weight.inputAccessoryView = toolbar
        
        memo.inputAccessoryView = toolbar0

        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        self.PlayButton.isHidden = true

    }
    func textViewDidChange(_ textView: UITextView) {
        let beforeStr: String = memo.text // 文字列をあらかじめ取得しておく
        if memo.text.count > 50 { // 10000字を超えた時
            // 以下，範囲指定する
            let zero = beforeStr.startIndex
            let start = beforeStr.index(zero, offsetBy: 0)
            let end = beforeStr.index(zero, offsetBy: 50)
            memo.text = String(beforeStr[start...end])
            textValidate.isHidden = false
            textValidate.text = "備考は50文字以内にして下さい"
        }
    }
    @objc func done() {
        if currentTextField == event{
            event.endEditing(true)
            event.text = "\(selectedEvent[pickerview.selectedRow(inComponent: 0)])"
        }else if currentTextField == PB1{
            PB1.endEditing(true)
            PB1.text = "\(selectedPB1[pickerview.selectedRow(inComponent: 0)])"
        }else if currentTextField == PB2{
            PB2.endEditing(true)
            PB2.text = "\(selectedPB2[pickerview.selectedRow(inComponent: 0)])"
        }else if currentTextField == height{
            height.endEditing(true)
            height.text = "\(selectedHeight[pickerview.selectedRow(inComponent: 0)])"
        }else if currentTextField == weight{
            weight.endEditing(true)
            weight.text = "\(selectedWeight[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    @objc func done0() {
        self.view.endEditing(true)
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == event {
            return selectedEvent.count
        }else if currentTextField == PB1{
            return selectedPB1.count
        }else if currentTextField == PB2{
            return selectedPB2.count
        }else if currentTextField == height{
            return selectedHeight.count
        }else if currentTextField == weight{
            return selectedWeight.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == event {
            return selectedEvent[row]
        }else if currentTextField == PB1{
            return selectedPB1[row]
        }else if currentTextField == PB2{
            return selectedPB2[row]
        }else if currentTextField == height{
            return selectedHeight[row]
        }else if currentTextField == weight{
            return selectedWeight[row]
        }else{
            return ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
//        if currentTextField == event{
//            currentTextField.inputView = pickerview
//        }else{
//            print("nil")
//        }
        if currentTextField == event {
            currentTextField.inputView = pickerview
        }else if currentTextField == PB1{
            currentTextField.inputView = pickerview
        }else if currentTextField == PB2{
            currentTextField.inputView = pickerview
        }else if currentTextField == height{
            currentTextField.inputView = pickerview
        }else if currentTextField == weight{
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
        print("選択できた！")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("yes！")
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
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ResultView") {
            
        }else{
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
                    // "popoverVC"はポップアップ用のVCに後ほど設定
            let vc = storyboard.instantiateViewController(withIdentifier: "popoverVC") as! PopoverViewController
            //        vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.delegate = self
            if sender != nil {
                if let button = sender {
                            // UIButtonからポップアップが出るように設定
                    popover.sourceRect = (button as! UIButton).bounds
                    popover.sourceView = (sender as! UIView)
                }
            }
            self.present(vc, animated: true, completion:nil)
        }

    }

    // 表示スタイルの設定
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // .noneを設定することで、設定したサイズでポップアップされる
        return .none
    }
    
    func fetchProducts(){
        let productIdentifier:Set = ["com.trackOnline.consumable.1"] // 製品ID
        let productsRequest: SKProductsRequest = SKProductsRequest.init(productIdentifiers: productIdentifier)
        productsRequest.delegate = self
        productsRequest.start()
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                print("Transaction Failed \(transaction)")
            case .purchased, .restored:
//                receiptValidation(url: "https://buy.itunes.apple.com/verifyReceipt")
                queue.finishTransaction(transaction)
                print("Transaction purchased or restored: \(transaction)")

                let now = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
                let timenow = formatter.string(from: now as Date)
                let date1 = Date()
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .short
                let date = formatter1.string(from: date1)
                let date2 = Date()
                let formatter2 = DateFormatter()
                formatter2.setLocalizedDateFormatFromTemplate("jm")
                let time = formatter2.string(from: date2)

                            //ここから動画DB格納定義
                if self.videoURL != nil{
                    self.segueNumber = 1
                    let storageReference = Storage.storage().reference().child("purchase").child("premium").child("uuid").child("\(self.currentUid)").child("post").child("\(timenow)"+"_"+"\(self.nameLabel.text!)").child("\(timenow)"+"_"+"\(self.nameLabel.text!).mp4")
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
                    let storageReferenceImage = Storage.storage().reference().child("purchase").child("premium").child("uuid").child("\(self.currentUid)").child("post").child("\(timenow)"+"_"+"\(self.nameLabel.text!)").child("\(timenow)"+"_"+"\(self.nameLabel.text!).png")
                    storageReferenceImage.putData(self.data!, metadata: nil) { metadata, error in
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
                }else{
                    self.segueNumber = 0
                }
                if self.memo.text == ""{
                    self.memo.text = "コメントなし"
                }
                let postData = ["postID":"\(timenow)"+"_"+"\(self.nameLabel.text!)","uuid":"\(self.currentUid)","userName":"\(self.nameLabel.text!)","height":"\(self.height.text!)","weight":"\(self.weight.text!)","event":"\(self.event.text!)","PB1":"\(self.PB1.text!)","PB2":"\(self.PB2.text!)","memo":"\(self.memo.text!)","answerFlag":"0","goodButton":"0","badButton":"0","date":"\(date)","time":"\(time)" as Any] as [String : Any]
                let userData = ["uuid":"\(self.currentUid)","userName":"\(self.nameLabel.text!)","status":"1"]
                let ref0 = self.Ref.child("purchase").child("premium").child("uuid").child("\(self.currentUid)").child("post").child("\(timenow)"+"_"+"\(self.nameLabel.text!)")
                let ref1 = self.Ref.child("purchase").child("premium").child("post").child("\(timenow)"+"_"+"\(self.nameLabel.text!)")
                let ref2 = self.Ref.child("purchase").child("premium").child("userList").child("\(self.currentUid)")

                ref0.setValue(postData)
                ref1.setValue(postData)
                ref2.updateChildValues(userData)
                self.textValidate.isHidden = true
                //            self.event.text = ""
                //            self.PB.text = ""
                //            self.height.text = ""
                //            self.weight.text = ""
                //            self.memo.text = ""
                //            self.videoURL = nil
                //            self.imageView.image = UIImage(named: "斜線re.png")
                            print("OK")
                //            self.performSegue(withIdentifier: "ResultView", sender: true)
                self.dismiss(animated: true, completion: nil)
//                self.performSegue(withIdentifier: "ResultView", sender: true)
            case .deferred, .purchasing:
                print("Transaction in progress: \(transaction)")
            @unknown default:
                break
            }
        }
    }

    @IBAction func didTapBuy(_ sender: Any) {
        guard  let myProduct = myProduct else {
            return
        }
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first{
            myProduct = product
            print(product)
        }
    }

    @IBAction func sendVideo(_ sender: Any) {
        textValidate.isHidden = true

        if event.text?.count == 0 {
            textValidate.isHidden = false
            textValidate.text = "専門種目を選択してください"
            return
        }else if PB1.text?.count == 0 {
            textValidate.isHidden = false
            textValidate.text = "自己ベストを入力してください"
            return
        }else if PB2.text?.count == 0 {
            textValidate.isHidden = false
            textValidate.text = "自己ベストを入力してください"
            return
        }else if height.text?.count == 0 {
            textValidate.isHidden = false
            textValidate.text = "身長を入力してください"
            return
        }else if weight.text?.count == 0 {
            textValidate.isHidden = false
            textValidate.text = "体重を入力してください"
            return
        }else if self.videoURL == nil{
            textValidate.isHidden = false
            textValidate.text = "動画を選択してください"
            return
        }

        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で送信します。一度送信すると内容を修正できません。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            guard  let myProduct = self.myProduct else {
                return
            }
            if SKPaymentQueue.canMakePayments(){
                let payment = SKPayment(product: myProduct)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)

            }
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

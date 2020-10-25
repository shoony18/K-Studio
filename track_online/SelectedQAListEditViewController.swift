//
//  SelectedQAListEditViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/09.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary
class SelectedQAListEditViewController: UIViewController {

    var roomArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var flag: String?
    var selectedspeciality: String?
    var selectedQAContent: String?
    var selectedAnswer: String?
    var selectedUid: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid
    var pickerview: UIPickerView = UIPickerView()
    var selectedSpeciality:[String] = []
    var txtActiveView = UITextView()
    // 現在選択されているTextField
    var selectedTextView:UITextView?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sankouLabel: UILabel!
    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var QASpeciality: UILabel!
    @IBOutlet weak var QAContent: UITextView!
    @IBOutlet weak var sakouContent: UITextView!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var trackAnswer: UILabel!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var resendQA: UIButton!
    
    override func viewDidLoad() {

//        pickerview.delegate = self
//        pickerview.dataSource = self
//        pickerview.tag = 0

        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        // インプットビュー設定
//        QASpeciality.inputView = pickerview
//        QASpeciality.inputAccessoryView = toolbar
        QAContent.inputAccessoryView = toolbar

        userQA()
        // Do any additional setup after loading the view.

        super.viewDidLoad()
    }

    @objc func done() {
        self.view.endEditing(true)
    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }

//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return selectedSpeciality.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return selectedSpeciality[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
//        return QASpeciality.text = selectedSpeciality[row]
//    }
//
    func userQA(){
        QASpeciality.text = selectedspeciality
        if flag == "answer"{
            titleLabel.text = "回答"
            QAContent.text = selectedAnswer
            sankouLabel.text = "質問"
            sakouContent.text = selectedQAContent
            sakouContent.isEditable = false
        }else{
            titleLabel.text = "質問"
            QAContent.text = selectedQAContent
            sakouContent.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        sakouContent.isEditable = false
                
        }
//            let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child(text!)
//            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
//              // Get user value
//              let value = snapshot.value as? NSDictionary
//              let key = value?["QASpeciality"] as? String ?? ""
//                if key.isEmpty{
//                    self.QASpeciality.text = "-"
//                }else{
//                    self.QASpeciality.text = key
//                }
//              // ...
//              }) { (error) in
//                print(error.localizedDescription)
//            }
//            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
//              // Get user value
//              let value = snapshot.value as? NSDictionary
//              let key = value?["TextViewQAcontent"] as? String ?? ""
//              self.userQAText.text = key
//
//              // ...
//              }) { (error) in
//                print(error.localizedDescription)
//            }
////            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
////              // Get user value
////              let value = snapshot.value as? NSDictionary
////              let key = value?["trackAnswer"] as? String ?? ""
////              self.trackAnswer.text = key
////              // ...
////              }) { (error) in
////                print(error.localizedDescription)
////            }
////            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
////              // Get user value
////                let value = snapshot.value as? NSDictionary
////                let key = value?["sankouURL"] as? String ?? ""
////    //          self.trackAnswer.text = key
////    //            let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
////                let attributedString = NSMutableAttributedString(string: key)
////                attributedString.addAttribute(.link,
////                                              value: key,
////                                              range: NSString(string: key).range(of: key))
////                self.sankouURL.attributedText = attributedString
////                // isSelectableをtrue、isEditableをfalseにする必要がある
////                // （isSelectableはデフォルトtrueだが説明のため記述）
////                self.sankouURL.isSelectable = true
////                self.sankouURL.isEditable = false
////                self.sankouURL.delegate = self as UITextViewDelegate
////                print("sankouURL")
////
////              // ...
////              }) { (error) in
////                print(error.localizedDescription)
////            }
            
        }
//        func download(){
//            let textVideo:String = text!+".mp4"
//            let textImage:String = text!+".png"
//            let refVideo = Storage.storage().reference().child("QA").child("\(currentUid)").child(text!).child("\(textVideo)")
//            print("\(refVideo)")
//            refVideo.downloadURL{ url, error in
//            if (error != nil) {
//                print("QA添付動画なし")
//                let imageView: UIImageView = self.UIimageView
//                // Placeholder image
//                let placeholderImage = UIImage(named: "rikujou_track_top.png")
//                imageView.image = placeholderImage
//            } else {
//                self.playUrl = url as NSURL?
//                print("download success!! URL:", url!)
//                print("QA添付動画あり")
//            }
//            }
//            let refImage = Storage.storage().reference().child("QA").child("\(currentUid)").child(text!).child("\(textImage)")
//
//            // Load the image using SDWebImage
//            if UIimageView != nil {
//                let imageView: UIImageView = self.UIimageView
//            // Placeholder image
//                let placeholderImage = UIImage(named: "placeholder.png")
//                imageView.sd_setImage(with: refImage, placeholderImage: placeholderImage)
//            }
//
//        }

    @IBAction func resendQA(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この内容で送信していいですか？", preferredStyle:  UIAlertController.Style.alert)
        if flag == "answer"{
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            (action: UIAlertAction!) -> Void in
//                let ref0 = Database.database().reference().child("QA").child("\(self.currentUid)").child("public").child("\(self.text!)")
                let ref1 = Database.database().reference().child("QA").child("public").child("\(self.QASpeciality.text!)").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)")
                let ref2 = Database.database().reference().child("QA").child("public").child("全て").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)")
                let data = ["answer":"\(self.QAContent.text!)" as Any] as [String : Any]
//                ref0.updateChildValues(data)
                ref1.updateChildValues(data)
                ref2.updateChildValues(data)
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                            (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                            (action: UIAlertAction!) -> Void in
                let ref0 = Database.database().reference().child("QA").child("\(self.currentUid)").child("public").child("\(self.text!)")
                let ref1 = Database.database().reference().child("QA").child("public").child("\(self.QASpeciality.text!)").child("\(self.text!)")
                let ref2 = Database.database().reference().child("QA").child("public").child("全て").child("\(self.text!)")
                let data = ["QASpeciality":"\(self.QASpeciality.text!)","QAContent":"\(self.QAContent.text!)" as Any] as [String : Any]
                ref0.updateChildValues(data)
                ref1.updateChildValues(data)
                ref2.updateChildValues(data)
                self.navigationController?.popViewController(animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SelectedQAListEditViewController: UITextViewDelegate{
//リターンキーでテキストフィールドを閉じる
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

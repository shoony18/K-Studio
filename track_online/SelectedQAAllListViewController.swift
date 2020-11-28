//
//  SelectedQAAllListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/28.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary

class SelectedQAAllListViewController: UIViewController ,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var userQAText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var trackAnswer: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var userNameQuestion: UILabel!
    @IBOutlet weak var userAnswerTextView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var sendAnswer: UIButton!
    @IBOutlet weak var makeAnswer: UIButton!
    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameHidden: UIButton!
    
    @IBOutlet weak var QAmuraUserAnswerTableView: UITableView!
    
    var roomArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    var goodButtonValue:String?
    var badButtonValue:String?
    let ref = Database.database().reference()
    var fromUidArray = [String]()
    var answerArray = [String]()
    var userNameAnswerArray = [String]()
    var TimeArray = [String]()
    var DateArray = [String]()
    var sankouURLArray = [String]()
    var goodButtonArray = [String]()
    var fromUidArray_r = [String]()
    var answerArray_r = [String]()
    var userNameAnswerArray_r = [String]()
    var TimeArray_r = [String]()
    var DateArray_r = [String]()
    var sankouURLArray_r = [String]()
    var goodButtonArray_r = [String]()
    
    var pickerview: UIPickerView = UIPickerView()
    var countAnswer:Int?
    var answerData: String?
    var countPoint = Int()
    var pointEaring:String?
    var Qdate:String?
    var Qtime:String?
    
    
    override func viewDidLoad() {
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        QAmuraUserAnswerTableView.dataSource = self
        QAmuraUserAnswerTableView.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        // インプットビュー設定
        answerTextView.inputAccessoryView = toolbar
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameAnswerArray.removeAll()
        answerArray.removeAll()
        DateArray.removeAll()
        TimeArray.removeAll()
        sankouURLArray.removeAll()
        userQuestion()
        userAnswer()
        sendAnswerValidate()
        super.viewWillAppear(animated)
    }
    @objc func done() {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameAnswerArray.count
    }
    
    
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.QAmuraUserAnswerTableView.dequeueReusableCell(withIdentifier: "TableViewCell2", for: indexPath as IndexPath) as? QATableViewCell
        cell!.userNameAnswer1_2.text = self.userNameAnswerArray_r[indexPath.row] //①
        cell!.answer1_2.text = self.answerArray_r[indexPath.row]
        cell!.date1_2.text = self.DateArray_r[indexPath.row] //①
        cell!.time1_2.text = self.TimeArray_r[indexPath.row] //①
        //        cell!.sankouURL1_2.text = self.sankouURLArray[indexPath.row] //①
        //        cell!.goodButton1_2.setImage(UIImage(named: "goodButton\(goodButtonArray_r[indexPath.row])"), for: .normal)
        cell?.flag1_2.addTarget(self, action: #selector(tapCellButton(_:)), for: .touchUpInside)
        //タグを設定
        //        cell!.goodButton1_2.tag = indexPath.row
        return cell!
    }
    @objc func tapCellButton(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この回答は問題があるとして報告しますか？", preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let ref0 = Database.database().reference().child("QA").child("public").child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackAnswer").child("\(self.fromUidArray_r[sender.tag])")
            let ref1 = Database.database().reference().child("QA").child("public").child("全て").child("\(self.text!)").child("trackAnswer").child("\(self.fromUidArray_r[sender.tag])")
            let ref2 = Database.database().reference().child("QA").child("\(self.fromUidArray_r[sender.tag])").child("warningFlag").child("\(self.currentUid)").childByAutoId()
            let ref3 = Database.database().reference().child("QA").child("warningFlag").child("\(self.text!)").child("\(self.currentUid)").childByAutoId()
            let ref4 = Database.database().reference().child("QA").child("\(self.fromUidArray_r[sender.tag])").child("public").child("answer").child("\(self.text!)")
            let data1 = ["warningFlag":"1"];
            ref0.updateChildValues(data1)
            ref1.updateChildValues(data1)
            ref2.updateChildValues(data1)
            ref3.updateChildValues(data1)
            ref4.updateChildValues(data1)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func userAnswer(){
        let ref0 = Database.database().reference().child("QA").child("public").child("\(selectedSpeciality!)").child("\(text!)").child("trackAnswer")
        ref0.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let fromUid = snap!["fromUid"] as? String {
                        self.fromUidArray.append(fromUid)
                        self.fromUidArray_r = self.fromUidArray.reversed()
                        if fromUid == self.currentUid{
                            self.makeAnswer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
                            self.answerTextView.textColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
                            self.makeAnswer.isEnabled = false
                            self.nameLabel.textColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
                            self.nameHidden.isEnabled = false
                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let userNameAnswer = snap!["fromUserName"] as? String {
                        self.userNameAnswerArray.append(userNameAnswer)
                        self.userNameAnswerArray_r = self.userNameAnswerArray.reversed()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let answer = snap!["answer"] as? String {
                        self.answerArray.append(answer)
                        self.answerArray_r = self.answerArray.reversed()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let date = snap!["date"] as? String {
                        self.DateArray.append(date)
                        self.DateArray_r = self.DateArray.reversed()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let time = snap!["time"] as? String {
                        self.TimeArray.append(time)
                        self.TimeArray_r = self.TimeArray.reversed()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let sankouURL = snap!["sankouURL"] as? String {
                        self.sankouURLArray.append(sankouURL)
                        self.sankouURLArray_r = self.sankouURLArray.reversed()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let goodButton = snap!["goodButton"] as? String {
                        self.goodButtonArray.append(goodButton)
                        self.goodButtonArray_r = self.goodButtonArray.reversed()
                    }
                }
                self.QAmuraUserAnswerTableView.reloadData()
            }
        }
        )
        
    }
    func userQuestion(){
        date.text = selectedDate
        time.text = selectedTime
        speciality.text = selectedSpeciality
        userNameQuestion.text = selectedUserNameQuestion
        
        //            let good_picture0 = UIImage(named: "hand.thumbsup")
        //            self.goodButton.setImage(good_picture0, for: .normal)
        //            let bad_picture0 = UIImage(named: "hand.thumbsdown")
        //            self.badButton.setImage(bad_picture0, for: .normal)
        
        let ref0 = Database.database().reference().child("QA").child("public").child("\(selectedSpeciality!)").child("\(text!)")
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let key = value?["QAContent"] as? String ?? ""
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
    
    func sendAnswerValidate(){
        nameLabel.text = currentUserName
        nameLabel.textColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
        nameLabel.backgroundColor = UIColor(red: 226/255, green: 225/255, blue: 230/255, alpha: 1)
        nameHidden.isEnabled = false
        nameHidden.setTitle("非表示", for: .normal)
        nameHidden.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        answerTextView.isEditable = false
        answerTextView.text = "質問に回答する（1文字〜100字）"
        answerTextView.textColor = UIColor(red: 176/255, green: 176/255, blue: 176/255, alpha: 1)
        answerTextView.backgroundColor = UIColor(red: 226/255, green: 225/255, blue: 230/255, alpha: 1)
        sendAnswer.isEnabled = false
        sendAnswer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        if currentUid == selectedUid{
            makeAnswer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
            makeAnswer.isEnabled = false
        }
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
    @IBAction func makeAnswerButtonTapped(_ sender: Any) {
        nameLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        nameLabel.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 234/255, alpha: 1)
        nameHidden.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        nameHidden.isEnabled = true
        answerTextView.text = ""
        answerTextView.isEditable = true
        answerTextView.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        answerTextView.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 234/255, alpha: 1)
        sendAnswer.isEnabled = true
        sendAnswer.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        makeAnswer.isEnabled = false
        makeAnswer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }
    
    @IBAction func sendAnswer(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "この回答を送信していいですか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let ref1 = Database.database().reference().child("QA").child("public")
            ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["date"] as? String ?? ""
                self.Qdate = key
            })
            ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["time"] as? String ?? ""
                self.Qtime = key
            })
            
            // 回答数の加算
            ref1.child("全て").child("\(self.text!)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let key = value?["countAnswer"] as? String ?? ""
                if key.isEmpty{
                }else{
                    self.countAnswer = Int(key)! + 1
                    print(String(self.countAnswer!))
                    print("\(self.countAnswer!)")
                    let data = ["countAnswer":String(self.countAnswer!)]
                    let data_r = ["fcmTrigger":"\(self.answerTextView.text!)"]
                    ref1.child("\(self.selectedSpeciality!)").child("\(self.text!)").updateChildValues(data)
                    let ref1_1 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("public").child("\(self.text!)")
                    let ref1_2 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("public").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)")
                    let ref1_3 = Database.database().reference().child("QA").child("\(self.selectedUid!)").child("public").child("\(self.text!)").child("fcmTrigger")
                    ref1_1.updateChildValues(data)
                    ref1_2.updateChildValues(data_r)
                    ref1_3.updateChildValues(data_r)
                    
                    ref1.child("全て").child("\(self.text!)").updateChildValues(data)
                    
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
                    let data1 = ["answer":"\(self.answerTextView.text!)","goodButton":"0","badButton":"0","date":"\(date)","time":"\(time)","fromUid":"\(self.currentUid)","fromUserName":"\(self.nameLabel.text!)","registeredUserName":"\(self.currentUserName)","sankouURL":""]
                    ref1.child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)").updateChildValues(data1)
                    ref1.child("全て").child("\(self.text!)").child("trackAnswer").child("\(self.currentUid)").updateChildValues(data1)
                    
                    let data0 = ["answer":"\(self.answerTextView.text!)","QAName":"\(self.text!)","userName":"\(self.userNameQuestion.text!)","QAContent":"\(self.userQAText.text!)","time":"\(time)","date":"\(date)","QASpeciality":"\(self.selectedSpeciality!)","countAnswer":String(self.countAnswer!),"uuid":"\(self.selectedUid!)","sankouURL":"","Qdate":"\(self.Qdate!)","Qtime":"\(self.Qtime!)","warningFlag":"0","goodButton":"0","badButton":"0"]
                    
                    let ref3 = Database.database().reference().child("QA").child("\(self.currentUid)").child("public").child("answer").child("\(self.text!)")
                    ref3.updateChildValues(data0)
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            
            self.navigationController?.popViewController(animated: true)
            
        }
        )
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

